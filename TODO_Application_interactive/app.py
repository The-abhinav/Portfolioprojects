from flask import Flask, request, jsonify, render_template

app = Flask(__name__, template_folder='my_templates')
todos = []

@app.route('/api/todo', methods=['GET'])
def get_todos():
    return jsonify(todos)

@app.route('/api/todo', methods=['POST'])
def create_todo():
    new_todo = {
        'task': request.form.get('task')
    }
    todos.append(new_todo)
    return jsonify(new_todo), 201

@app.route('/', methods=['GET'])
def index():
    return render_template('index.html', todos=todos)

if __name__ == '__main__':
    app.run(port=8888)
