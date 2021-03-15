import requests
from requests.exceptions import RequestException
from contextlib import closing
from bs4 import BeautifulSoup as bs
import dbconnect
import pandas
from slimit import ast
from slimit.parser import Parser
from slimit.visitors import nodevisitor
import json

conn = dbconnect.connect()

def simple_get(url):
    # Attempts to get the content at url' by making an HTTP GET request.
    # If the content-type of response is some kind of HTML or XML, return the
    # text content, otherwise return None.

    try:
        with closing(requests.get(url, stream=True)) as resp:
            if is_good_response(resp):
                return resp.content
            else:
                return None
    except RequestException as e:
        log_error('Error during requests to {0} : {1}'.format(url, str(e)))
        return None

def is_good_response(resp):
    content_type = resp.headers['Content-Type'].lower()
    return (resp.status_code == 200
            and content_type is not None
            and content_type.find('html') > -1)

def log_error(e):
    print(e)

rootURL = 'https://matchcenter.mlssoccer.com/matchcenter/2020-03-01-portland-timbers-vs-minnesota-united-fc/feed'
#rootURL = 'file:///C:/Users/ebrig/Desktop/python/output1.html'
html = simple_get(rootURL)

soup = bs(html, 'html.parser')
match = str(soup.find_all("script", type="text/javascript")[3].string)

#print(type(bar.string), str(bar.string))
tree = Parser().parse(match)

obj = next(node.right for node in nodevisitor.visit(tree)
           if (isinstance(node, ast.Assign) and
               node.left.to_ecma() == 'window.bootstrap'))

match_data = json.loads(obj.to_ecma())
print(json.dumps(match_data, indent=4, sort_keys=True, ensure_ascii=False))

with open('match_data.json', 'w') as outfile:
    json.dump(match_data, fp=outfile, indent=4, sort_keys=True, ensure_ascii=True)

#match_data = json.loads(obj.to_ecma())
#print(match_data)
