from flask import Flask, render_template
from pymongo import MongoClient
import certifi

app = Flask(__name__)

connection = 'mongodb+srv://allisonf:MlyO2CyoH7PVYQdr@cluster0.dno94re.mongodb.net/?retryWrites=true&w=majority'
client = MongoClient(connection, tlsCAFile=certifi.where())

db = client.get_database('chatroom')
users = db.get_collection('users')
messages = db.get_collection('messages')

users.delete_one({"_id": 11})

users.delete_many({"_id": {"$lt": 6}})
example_users = [
    {"_id": 5, "username": "Rick"},
    {"_id": 4, "username": "Morty"},
    {"_id": 3, "username": "Summer"},
    {"_id": 2, "username": "Jerry"},
    {"_id": 1, "username": "Beth"},
    {"_id": 0, "username": "Prince Nebulon"}
]
users.insert_many(example_users)

messages.delete_many({"sender_id": {"$lt": 6}})
messages.delete_one({"_id": 19})
example_messages = [
    {"_id": 60, "sender_id": 5, "recipient_id": 11, "content": "Listen to me, I need your help on an adventure", "time": "01/31 03:32 PM"},
    {"_id": 61, "sender_id": 5, "recipient_id": 11, "content": "Eh, n e e d is a strong word", "time": "01/31 03:33 PM"},
    {"_id": 62, "sender_id": 5, "recipient_id": 11, "content": "It wouldn't be terrible though", "time": "01/31 03:43 PM"},
    {"_id": 50, "sender_id": 4, "recipient_id": 11, "content": "Hi I'm Morty!", "time": "02/14 04:15 PM"},
    {"_id": 40, "sender_id": 3, "recipient_id": 11, "content": "Don't text me again", "time": "02/18 05:29 PM"},
    {"_id": 30, "sender_id": 2, "recipient_id": 11, "content": "Uhh hello, who are you? This is Jerry.", "time": "03/12 06:02 PM"},
    {"_id": 19, "sender_id": 11, "recipient_id": 1, "content": "Hi Beth, what's up", "time": "03/14 02:21 AM"},
    {"_id": 20, "sender_id": 1, "recipient_id": 11, "content": "Honey, I think it's time you went to bed", "time": "03/14 02:45 AM"},
    {"_id": 10, "sender_id": 0, "recipient_id": 11, "content": "HA!", "time": "03/17 01:38 AM"},
    {"_id": 11, "sender_id": 0, "recipient_id": 11, "content": "wait", "time": "03/17 01:38 AM"},
    {"_id": 12, "sender_id": 0, "recipient_id": 11, "content": "HA!", "time": "03/17 01:39 AM"},

]
messages.insert_many(example_messages)


# if __name__ == '__main__':
#     app.run(debug=True, host='128.61.55.52', port=5000)