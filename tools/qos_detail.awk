BEGIN {
    sent = 0;
    received = 0;
    bytes = 0;
    total_delay = 0;
    total_jitter = 0;
    start_time = 999999;
    end_time = 0;
}

function to_int(s,    t) {
    t = s;
    gsub(/[^0-9]/, "", t);
    return t + 0;
}

function to_nodeid(addr,    t, a, id) {
    t = addr;
    sub(/^\[/, "", t);
    split(t, a, ":");
    id = a[1];
    gsub(/[^0-9]/, "", id);
    return id + 0;
}

{
    event = $1;
    time = $2 + 0;
    node = to_int($3);
    layer = $4;
    pkt_id = $6;
    pkt_type = $7;
    pkt_size = $8 + 0;

    # Support common data types (project uses TCP).
    is_data = (pkt_type == "tcp" || pkt_type == "cbr");

    # Newer traces may include AGT; this repo's traces commonly don't.
    if (layer == "AGT") {
        if (is_data && event == "s") {
            sent++;
            if (!(pkt_id in send_time)) send_time[pkt_id] = time;
            if (time < start_time) start_time = time;
        } else if (is_data && event == "r") {
            received++;
            bytes += pkt_size;

            if (pkt_id in send_time) {
                delay = time - send_time[pkt_id];
                total_delay += delay;

                if (received > 1) {
                    var = delay - prev_delay;
                    if (var < 0) var = -var;
                    total_jitter += var;
                }
                prev_delay = delay;
            }

            if (time > end_time) end_time = time;
        }
    }

    # Older NS2 wireless traces: often no AGT layer is present.
    # We approximate end-to-end by:
    # - sent:  RTR 's' at source node
    # - recv:  MAC 'r' at destination node
    else if (is_data && NF >= 15) {
        src = to_nodeid($14);
        dst = to_nodeid($15);

        if (layer == "RTR" && event == "s" && node == src) {
            sent++;
            if (!(pkt_id in send_time)) send_time[pkt_id] = time;
            if (time < start_time) start_time = time;
        } else if (layer == "MAC" && event == "r" && node == dst) {
            received++;
            bytes += pkt_size;

            if (pkt_id in send_time) {
                delay = time - send_time[pkt_id];
                total_delay += delay;

                if (received > 1) {
                    var = delay - prev_delay;
                    if (var < 0) var = -var;
                    total_jitter += var;
                }
                prev_delay = delay;
            }

            if (time > end_time) end_time = time;
        }
    }
}

END {
    if (start_time == 999999 || end_time <= start_time) {
        duration = 0;
    } else {
        duration = end_time - start_time;
    }

    if (duration > 0) {
        thr = (bytes * 8) / (duration * 1000); # Kbps
    } else {
        thr = 0;
    }

    if (sent > 0) {
        loss = ((sent - received) / sent) * 100;
        if (loss < 0) loss = 0;
    } else {
        loss = 0;
    }

    if (received > 0) {
        avg_delay_ms = (total_delay / received) * 1000;
        avg_jitter_ms = (total_jitter / received) * 1000;
    } else {
        avg_delay_ms = 0;
        avg_jitter_ms = 0;
    }

    # Output starts with the same 4 metrics as tools/qos.awk, then adds derivation fields.
    printf("%.2f\t%.2f\t%.2f\t%.2f\t%d\t%d\t%d\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\n",
        avg_delay_ms, thr, loss, avg_jitter_ms,
        sent, received, bytes,
        duration, start_time, end_time,
        total_delay, total_jitter);
}
