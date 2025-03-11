debImport "-f" "../sourcecode/rtl_list.txt" "-f" "../sourcecode/tb_list.txt"
wvCreateWindow
wvOpenFile -win $_nWave2 {/home/host/Desktop/project/CAM/workspace/*.fsdb}
debExit
