" PEP 8 Indent rule
setl tabstop=8
setl softtabstop=4
setl shiftwidth=4
setl smarttab
setl expandtab
setl autoindent
setl nosmartindent
setl cindent
setl textwidth=80
setl colorcolumn=80

" for virtualenv
let b:pythonworkon = "System"
python << EOF
import sys, os.path
import vim
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  sys.path.insert(0, project_base_dir)
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
  # Save virtual environment name to VIM variable
  vim.command("let b:pythonworkon = '%s'" % os.path.basename(project_base_dir))

  vim.command("if !exists('g:ref_pydoc_cmd') | let g:ref_pydoc_cmd = 'python -m pydoc' | endif")
EOF

function! Workon(venv)
  python << EOF
project_base_dir = os.environ['HOME'] + '/.virtualenvs/' + vim.eval('a:venv')
if os.path.isdir(project_base_dir):
  sys.path.insert(0, project_base_dir)
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
  # Save virtual environment name to VIM variable
  vim.command("let b:pythonworkon = '%s'" % os.path.basename(project_base_dir))
  vim.command("let g:ref_pydoc_cmd = 'python -m pydoc'")
else:
  vim.command("echoerr 'invalid virtualenv: %s'" % os.path.basename(project_base_dir))
EOF
endfunction
