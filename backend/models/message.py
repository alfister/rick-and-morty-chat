from flask import jsonify, request
from datetime import datetime
from app import users, messages
import uuid

class Message:

    def send_message(self, recipient_id):
        new_message = {
            "_id": uuid.uuid4().hex,
            "sender_id": 11,
            "recipient_id": int(recipient_id),
            "content": request.form.get('content'),
            "time": datetime.now().strftime("%d-%m-%Y %I:%M %p")
        }

        messages.insert_one(new_message)
        return jsonify(new_message), 200
    
    def get_chats(self):
        chats = users.find({"_id": {"$ne": 11}})
        return jsonify({"chats": list(chats)}), 200

    def get_one_chat(self, user_id):
        one_chat = messages.find({"$or": [
                                            {"sender_id": {"$eq": int(user_id)}},
                                            {"$and":[
                                                    {"sender_id": {"$eq": 11}},
                                                    {"recipient_id": {"$eq": int(user_id)}}
                                                    ]}
                                            ]})
        return jsonify({"one_chat": list(one_chat)}), 200
