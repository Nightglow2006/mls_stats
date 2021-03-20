from collections import UserList
from scrape.http_get import simple_get as get
from slimit import ast
from slimit.parser import Parser
from slimit.visitors import nodevisitor
from bs4 import BeautifulSoup as bs
import json

def get_match_data(url):
    html = get.simple_get(url)
    # * Use BeautifulSoup4 to parse the content of the site into an object,
    # * And search that object for the appropriate javascript block
    soup = bs(html, 'html.parser')
    match = str(soup.find_all("script", type="text/javascript")[3].string)
    
    # * Use slimit to parse the javascript block into a tree,
    # * traverse that tree, and store the result as JSON
    tree = Parser().parse(match)
    data = next(node.right for node in nodevisitor.visit(tree)
               if (isinstance(node, ast.Assign) and
                   node.left.to_ecma() == 'window.bootstrap'))
    match_data = json.loads(data.to_ecma())
    return match_data