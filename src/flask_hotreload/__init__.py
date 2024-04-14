from flask import Flask

app = Flask(__name__)

@app.route('/')
def root():
    return 'Hello, World!'

if __name__ == '__main__':
    # ホットリロードはwatchexecに任せる
    app.run(debug=True, use_reloader=False, host='0.0.0.0')
