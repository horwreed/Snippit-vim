if !has('python3')
    echo "Error: Required vim compiled with +python3"
    finish
endif

let s:default_settings = { 'quickfix_window_height': 10 }

function! Goto_window()
execute 'belowright copen'.10
endfunction

function! Snippit()

" We start the python code like the next line.

python3 << EOF
# the vim module contains everything we need to interface with vim from
# python. We need urllib for the web service consumer.
import vim, urllib.request, urllib.parse
import json

vim.eval('Goto_window()')

def read_description(desc):
    for line in desc.split('\n'):
    	vim.current.buffer.append(line)

# we define a timeout that we'll use in the API call. We don't want
# users to wait much.
TIMEOUT = 20
keywords = ['3', 'linear', 'search']
keywords = ' '.join(['20']+keywords)
params = urllib.parse.quote(keywords)
URL = "http://snip-index.herokuapp.com/search/py/3%20linear%20search"

try:
    # Get the posts and parse the json response
    response = urllib.request.urlopen(URL)
    html = response.read()
    results = json.loads(html.decode("utf-8"))

    del vim.current.buffer[:]
    vim.current.buffer[0] = 80*"-"

    for result in results:
    	vim.current.buffer.append(f"func: {result[3]}")
    	read_description(f"description: {result[4]}")
    	vim.current.buffer.append(80*"-")

except Exception as e:
    print(e)

EOF
" Here the python code is closed. We can continue writing VimL or python again.
endfunction

command Snippit execute 'nnoremap <buffer>'.Snippit().' :call Snippit()<CR>'
