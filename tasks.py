import time

from invoke import Context, Collection, task
from telnetlib import Telnet
from datetime import datetime, timedelta

@task()
def renode(ctx):
    """Spawn Renode and attach to its monitor"""
    ctx.run("./start-headless.sh", asynchronous=True)

    print("Letting Renode boot...")
    time.sleep(3)

    retry_until = datetime.now() + timedelta(seconds=3)
    while datetime.now() < retry_until:
        try:
            ctx.run('telnet 127.0.0.1 33334', pty=True)
        except Exception as e:
            time.sleep(0.5)

@task()
def console(ctx):
    """Connect to Renode's UART"""
    ctx.run('telnet 127.0.0.1 33335', pty=True)

@task()
def gdb(ctx):
    """Connect to Renode's GDB connection"""
    ctx.run("arm-none-eabi-gdb-py "
            "--eval-command=\"target remote :3333\" "
            "--se build/renode-example.elf", 
            pty=True)

@task()
def test(ctx):
    """Run tests locally"""
    ctx.run("./run_tests.sh", pty=True)

ns = Collection()
ns.add_task(renode)
ns.add_task(console)
ns.add_task(gdb)
ns.add_task(test)
