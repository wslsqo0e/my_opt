#!/usr/bin/env python3

import subprocess
from datetime import datetime
import os

TARGET_URL = "10.0.0.1"  # 将其替换为你想要 ping 的网址
REBOOT_COMMAND = "sudo reboot"  # 重启命令，需要 sudo 权限

now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def ping(url):
    """Ping 指定的网址，返回 True 如果成功，False 如果失败。"""
    try:
        # 使用 ping 命令，-c 1 表示只发送一个包，-W 5 表示等待 5 秒超时
        result = subprocess.run(["ping", "-c", "1", "-W", "5", url],
                                capture_output=True, text=True, check=True)
        return True
    except subprocess.CalledProcessError as e:
        print(f"{now}: Ping failed for {url}: {e}")
        return False
    except FileNotFoundError:
        print(f"{now}: Error: 'ping' command not found. Please ensure it's installed.")
        return False

def reboot_system():
    """执行重启命令。"""
    print(f"{now}: Ping failed. Attempting to reboot the system...")
    try:
        subprocess.run(REBOOT_COMMAND, shell=True, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error rebooting: {e}")
        print("Please check if the reboot command requires a password and if the script has sudo privileges.")
    except FileNotFoundError:
        print("Error: 'sudo' command not found. Please ensure it's installed if the reboot command requires it.")

if __name__ == "__main__":
    if not ping(TARGET_URL):
        reboot_system()
    else:
        print(f"{now}: Ping to {TARGET_URL} successful.")
