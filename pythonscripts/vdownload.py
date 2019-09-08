import threading
import subprocess
import os

if os.path.exists('./templog.txt'):
    os.remove('./templog.txt')

commands = []
urls = []

def run_command(command):
    p = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    return iter(p.stdout.readline, b'')

command = 'greenclip print'.split()

for line in run_command(command):
    r = line.decode('utf-8').replace('\n', '')
    if 'youtube.com' in r:
        commands.append('youtube-dl --get-filename ' + r)
        urls.append(r)

def run(cmd):
    name = cmd
    out = open('./templog.txt', 'a')
    err = open('/dev/null', 'w')
    p = subprocess.Popen(cmd.split(), stdout=out, stderr=err)
    p.wait()

#proc = [threading.Thread(target=run, kwargs={'cmd':cmd}) for cmd in commands]
proc = []
for cmd in commands:
    proc.append(threading.Thread(target=run, kwargs={'cmd':cmd}))
[p.start() for p in proc]
[p.join() for p in proc]

finalp = subprocess.Popen(['cat templog.txt | rofi -dmenu'], bufsize=2048, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, close_fds=True)

finalp.wait()
res = finalp.stdout.read()
print(res)

