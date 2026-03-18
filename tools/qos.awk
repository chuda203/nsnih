BEGIN {
    sent = 0;
    received = 0;
    bytes = 0;
    total_delay = 0;
    total_jitter = 0;
    start_time = 999999;
    end_time = 0;
}

{
    event = $1;
    time = $2;
    trace_type = $4;
    pkt_id = $6;
    pkt_type = $7;
    pkt_size = $8;

    if (trace_type == "AGT") {
        if (event == "s") {
            sent++;
            send_time[pkt_id] = time;
            if (time < start_time) start_time = time;
        }
        else if (event == "r") {
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
    duration = end_time - start_time;
    
    if (duration > 0) {
        thr = (bytes * 8) / (duration * 1000);
    } else {
        thr = 0;
    }
    
    if (sent > 0) {
        loss = ((sent - received) / sent) * 100;
        if (loss < 0) loss = 0; # just in case
    } else {
        loss = 0;
    }
    
    if (received > 0) {
        avg_delay = (total_delay / received) * 1000;
        avg_jitter = (total_jitter / received) * 1000;
    } else {
        avg_delay = 0;
        avg_jitter = 0;
    }
    
    printf("%.2f\t%.2f\t%.2f\t%.2f\n", avg_delay, thr, loss, avg_jitter);
}
