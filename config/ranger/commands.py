# This is a sample commands.py.  You can add your own commands here.
#
# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# A simple command for demonstration purposes follows.
# -----------------------------------------------------------------------------

from __future__ import absolute_import, division, print_function

# You can import any python module as needed.
import os

# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import Command

common_fzf_opts = (
    "--no-sort --height=80% --layout=reverse --info=inline --select-1 --exit-0"
)


class fzf_select(Command):
    """
    :fzf_select

    Find a file using fzf.
    """

    def execute(self):
        import subprocess

        # match files and directories
        command = f"fd | fzf {common_fzf_opts}"
        cmd = self.fm.execute_command(command, stdout=subprocess.PIPE)
        stdout, _ = cmd.communicate()
        if cmd.returncode == 0:
            fzf_file = os.path.abspath(stdout.decode("utf-8").rstrip("\n"))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)


class fzf_ghq(Command):
    """
    :fzf_ghq

    Find a ghq managed directory using fzf.
    """

    def execute(self):
        import subprocess

        def ghq_root():
            cmd = self.fm.execute_command("ghq root", stdout=subprocess.PIPE)
            stdout, _ = cmd.communicate()
            if cmd.returncode != 0:
                self.fm.notify("ghq root directory not found", bad=True)
                raise
            return stdout.decode("utf-8").rstrip("\n")

        root = ghq_root()

        command = f"ghq list | fzf {common_fzf_opts}"
        cmd = self.fm.execute_command(command, stdout=subprocess.PIPE)
        stdout, _ = cmd.communicate()
        if cmd.returncode == 0:
            ghq_dir = os.path.abspath(
                os.path.join(root, stdout.decode("utf-8").rstrip("\n"))
            )
            self.fm.cd(ghq_dir)


class zoxide_query(Command):
    """
    :zoxide_query

    Find a directory using zoxide
    """

    def execute(self):
        import subprocess

        command = "zoxide query -i"
        env = os.environ
        env["_ZO_FZF_OPTS"] = common_fzf_opts
        cmd = self.fm.execute_command(command, stdout=subprocess.PIPE, env=env)
        stdout, _ = cmd.communicate()
        if cmd.returncode == 0:
            zoxide_dir = os.path.abspath(stdout.decode("utf-8").rstrip("\n"))
            self.fm.cd(zoxide_dir)
