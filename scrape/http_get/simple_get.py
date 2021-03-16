import requests
from requests.exceptions import RequestException
from contextlib import closing

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
    # Accepts a HTTP request response, checks for response code 200
    # with a valid and non-empty content.
    content_type = resp.headers['Content-Type'].lower()
    return (resp.status_code == 200
            and content_type is not None
            and content_type.find('html') > -1)

def log_error(e):
    print(e)