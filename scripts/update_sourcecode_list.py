# Author: Keyi Jiang
# E-mail: jky21@mails.tsinghua.edu.cn
# Date: 2025/1/17
# Description: For automatically updating rtl_list.txt and tb_list.txt
import os

source_dir = "../sourcecode/rtl"
output_file = "../sourcecode/rtl_list.txt"

v_files = []
for root, dirs, files in os.walk(source_dir):
    for file in files:
        if file.endswith(".v"):
            file_path = os.path.join(root, file)
            v_files.append(file_path.replace("\\", "/"))

with open(output_file, "w") as f:
    for v_file in v_files:
        f.write(v_file + "\n")

source_dir = "../sourcecode/tb"
output_file = "../sourcecode/tb_list.txt"

v_files = []
for root, dirs, files in os.walk(source_dir):
    for file in files:
        if file.endswith(".v"):
            file_path = os.path.join(root, file)
            v_files.append(file_path.replace("\\", "/"))

with open(output_file, "w") as f:
    for v_file in v_files:
        f.write(v_file + "\n")
