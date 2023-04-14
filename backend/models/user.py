from flask import jsonify, request
from app import users
import bcrypt
import uuid

class User:
    
    def register(self):
        new_user = {
            "_id": 11,
            "username": request.form.get('username'),
            "password": request.form.get('password')
        }

        user_found = users.find_one({'username': new_user['username']})
        
        if user_found:
            return jsonify({'error': 'username is taken, please choose another'}), 400
        else:
            # encrypt password
            new_user['password'] = bcrypt.hashpw(new_user['password'].encode('utf-8'), bcrypt.gensalt())
            users.insert_one(new_user)
            return jsonify({"_id": new_user['_id'], "username": new_user['username']}), 200

    def login(self):
        user_credentials = {
            "username": request.form.get('username'),
            "password": request.form.get('password')
        } 
                                  
        user = users.find_one({'username': user_credentials['username']})

        if user:
            print('found one')
            if bcrypt.checkpw(user_credentials['password'].encode('utf-8'), user['password']):
                return jsonify({"username": user_credentials['username']}), 200
            else:
                return jsonify({'error': 'invalid login credentials'}), 401
        else:
            return jsonify({'error': 'username not found'}), 404