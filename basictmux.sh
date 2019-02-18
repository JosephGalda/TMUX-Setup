#!/bin/bash
docker restart ak && docker restart ao
grep -v '^#' iftest.txt | head -n1 |  while read RN SN; do
tmux new -d -s Robots -n "${RN:0:4}"
tmux splitw -v -p 80
tmux splitw -v -p 71
tmux splitw -v -p 60
tmux splitw -h -p 50
tmux selectp -t 1 
tmux setw synchronize-panes on 
tmux send-keys -t 1 "sleep 2; docker exec -it ${RN:0:2} bash" C-m
tmux setw synchronize-panes off
sleep .5
tmux send-keys -t 1 "ssh ${RN}"
tmux send-keys -t 2 "ssh ${RN}"
tmux send-keys -t 3 "ssh ${RN}"
tmux send-keys -t 4 "remote_dash ${RN}"
tmux send-keys -t 5 "remote_rviz ${RN} ${SN}"
done

sleep 1

grep -v '^#' iftest.txt | tail -n +2 |  while read RN SN; do
tmux neww -n "${RN:0:4}" -t Robots  'bash -i'
tmux splitw -v -p 80
tmux splitw -v -p 71
tmux splitw -v -p 60
tmux splitw -h -p 50
tmux selectp -t 1 
tmux setw synchronize-panes on
tmux send-keys -t 1 "sleep 2; docker exec -it ${RN:0:2} bash" C-m
tmux setw synchronize-panes off 
sleep .5
tmux send-keys -t 1 "ssh ${RN}"
tmux send-keys -t 2 "ssh ${RN}"
tmux send-keys -t 3 "ssh ${RN}"
tmux send-keys -t 4 "remote_dash ${RN}"
tmux send-keys -t 5 "remote_rviz ${RN} ${SN}"
done

sleep 1
tmux neww -an MISC -t Robots  'bash -i'
tmux splitw -v -p 50
tmux splitw -v -p 50
tmux selectp -t 1
tmux splitw -v -p 50
tmux selectp -t 1
tmux send-keys -t 1 'tmux setw synchronize-panes on' C-m
tmux send-keys -t 1 'bash -i' C-m
tmux send-keys -t 1 'tmux setw synchronize-panes off' C-m
tmux select-window -t Robots:1
tmux -2 attach-session -t Robots 
