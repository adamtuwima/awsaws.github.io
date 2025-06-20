from mitmproxy import http

DOMAINS_TO_REPLACE = globals().get("DOMAINS_TO_REPLACE", [])

def domain_matches(host, domains):
    if "*" in domains:
        return True
    return any(domain in host for domain in domains)

def response(flow: http.HTTPFlow):
    host = flow.request.pretty_host
    content_type = flow.response.headers.get("content-type", "")
    if "text/html" in content_type and domain_matches(host, DOMAINS_TO_REPLACE):
        html = flow.response.content.decode("utf-8")
        injection = """
        <div style='position:fixed;bottom:0;left:0;width:100%;background:#000;color:#0f0;padding:10px;text-align:center;z-index:9999;'>
          🚀 Этот баннер загружен удалённо с GitHub Pages!
        </div>
        """
        html = html.replace("</body>", injection + "</body>")
        flow.response.content = html.encode("utf-8")