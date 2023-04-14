from flask import request, render_template
from models import user, message
from app import app

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/register', methods=['POST'])
def register():
    return user.User().register()
    
@app.route('/login', methods=['POST'])
def login():
    return user.User().login()

@app.route('/home/send-message', methods=['POST'])
def send_message():
    recipient_id = request.args.get('user_id')
    return message.Message().send_message(recipient_id)

@app.route('/home/get-chats', methods=['GET'])
def get_chats():
    return message.Message().get_chats()

@app.route('/home/get-one-chat', methods=['GET']) # take in id
def get_one_chat():
    user_id = request.args.get('user_id')
    return message.Message().get_one_chat(user_id)


if __name__ == '__main__':
    app.run(debug=True, host='128.61.55.52', port=5000)