from flask import Flask
import redis

app = Flask(__name__)
r = redis.Redis(host='redis', port=6379)

@app.route("/")
def hello():
    r.incr('hits')
    return f"Hello! This page has been visited {r.get('hits').decode()} times."



if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
