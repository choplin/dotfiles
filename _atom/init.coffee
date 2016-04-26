process.env.PATH =["/usr/local/bin", "/Users/okuno/.multirust/toolchains/stable/cargo/bin
", process.env.PATH].join(":")

getRepos = ->
  Promise.all(atom.project.getDirectories().map(
    atom.project.repositoryForDirectory.bind(atom.project)))

atom.commands.add 'atom-workspace', 'dot-atom:git-now', =>
  exec = require('child_process').exec
  command = "/usr/local/bin/git-now -A"

  getRepos().then (repos) ->
    if repos.length is 0
      atom.notifications.addWarning 'no repos found', {dismissable: true}
    else if repos.length > 1
      atom.notifications.addWarning 'more than one repositories found', {dismissable: true}
    else
      repo = repos[0]
      dir = repo.repo.workingDirectory
      exec command, {cwd: dir}, (error, stdout, stderr) ->
       if error
         atom.notifications.addError 'git now exited with error',
           {detail: error, dismissable: true}
       else if !!stderr
         atom.notifications.addWarning 'git now (with warnings)',
           {detail: stderr, dismissable: true}
       else
         repo.refreshStatus()
         atom.notifications.addSuccess 'Finished git now',
           {detail: stdout}
  .catch (e) ->
    atom.notifications.addError 'failed to get repositories',
      {detail: e, dismissable: true}
