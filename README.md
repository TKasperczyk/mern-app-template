<p align="center">
    <img src="https://i.imgur.com/bLw0pGe.png" alt="MERN App Template"></img>
</p>

------------

<p align="center">
    <h2 style="border: 0; padding: 0; margin: 0; margin-top: -55px;">
        <a href="https://github.com/TKasperczyk/mern-app-template-backend">Backend</a>
    </h2>
</p>
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/d1b1e2a8fec645d28b80009b980f7eac)](https://www.codacy.com/manual/Sarithis/mern-app-template-backend?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=TKasperczyk/mern-app-template-backend&amp;utm_campaign=Badge_Grade)
[![Build Status](https://travis-ci.com/TKasperczyk/mern-app-template-backend.svg?branch=master)](https://travis-ci.com/TKasperczyk/mern-app-template-backend)
[![Coverage Status](https://coveralls.io/repos/github/TKasperczyk/mern-app-template-backend/badge.svg?branch=master)](https://coveralls.io/github/TKasperczyk/mern-app-template-backend?branch=master)
[![Greenkeeper badge](https://badges.greenkeeper.io/TKasperczyk/mern-app-template-backend.svg)](https://greenkeeper.io/)
[![License](https://img.shields.io/github/license/TKasperczyk/mern-app-template-backend)](https://github.com/TKasperczyk/mern-app-template-backend/blob/master/LICENSE)
[![Known Vulnerabilities](https://snyk.io/test/github/TKasperczyk/mern-app-template-backend/badge.svg)](https://snyk.io/test/github/TKasperczyk/mern-app-template-backend)
<p align="center">
    <h2 style="border: 0; padding: 0; margin: 0;">
        <a href="https://github.com/TKasperczyk/mern-app-template-frontend">Frontend</a>
    </h2>
</p>
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/68064aaad8de4ec18eb0965a7cb74f26)](https://www.codacy.com/manual/Sarithis/mern-app-template-frontend?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=TKasperczyk/mern-app-template-frontend&amp;utm_campaign=Badge_Grade)
[![Build Status](https://travis-ci.com/TKasperczyk/mern-app-template-frontend.svg?branch=master)](https://travis-ci.com/TKasperczyk/mern-app-template-frontend)
[![Coverage Status](https://coveralls.io/repos/github/TKasperczyk/mern-app-template-frontend/badge.svg?branch=master)](https://coveralls.io/github/TKasperczyk/mern-app-template-frontend?branch=master)
[![Greenkeeper badge](https://badges.greenkeeper.io/TKasperczyk/mern-app-template-frontend.svg)](https://greenkeeper.io/)
[![License](https://img.shields.io/github/license/TKasperczyk/mern-app-template-frontend)](https://github.com/TKasperczyk/mern-app-template-frontend/blob/master/LICENSE)
[![Known Vulnerabilities](https://snyk.io/test/github/TKasperczyk/mern-app-template-frontend/badge.svg)](https://snyk.io/test/github/TKasperczyk/mern-app-template-frontend)

------------


## Overview
MERN App Template is a boilerplate for sessionless web applications. It offers a set of modules and components that can be used for further development. It utilises the following technologies:
- [Redux](https://redux.js.org/)
- [Socket.io](https://socket.io/)
- [MongoDB](https://www.mongodb.com/) + [Mongoose](https://mongoosejs.com/)
- [Redis](https://redis.io/)
- [Express.js](https://expressjs.com/)
- [Passport.js](http://www.passportjs.org/)
- [Clustering](https://nodejs.org/api/cluster.html)

The template includes modules that allow for implementing access lists, model-based user permissions, JWT authentication and more. The backend works on multiple threads and automatically balances the load between them.

## Installation and starting up (Linux)
```bash
git clone --recursive https://github.com/TKasperczyk/mern-app-template
cd mern-app-template
./install.sh
./run.sh
```

## Backend modules
### acl
Uses `config/acl.json` to optionally protect backend routes. It's already hooked up to Express in the [router](https://github.com/TKasperczyk/mern-app-template#router). Full documentation of this module can be found [here](https://github.com/nyambati/express-acl). The predefined access list is configured for two user roles: *user* and *admin*. Users can't use CRUD operations on `/api/user`. They can only access individual user records (`/api/user/*`), which are secured by the [permissions](https://github.com/TKasperczyk/mern-app-template#permissions) module.
### api
A simple collection of functions that allow for modifying database objects and performing other API tasks. It utilises a set of generic functions that can be used to perform CRUD operations without code repetition.
### auth
It's responsible for registering Passport strategies, securing Socket.io connections and processing incoming requests. It allows for user registration, signing in by using standard credentials (username and password) and JWT tokens.
### config
Imports the configuration from `config/config.json`. Allows for reloading the config without restarting the application by adding the `_reload` method to its export values.
### db
Exposes a connection to the database along with all the mongoose models residing in `app/db/mongo/models`.
### helpers
A set of helper functions that aren't strictly related to any of the backend modules.
### logger
Exposes two logger instances: appLogger and httpLogger. The second one acts as a middleware and is hooked up to Express. appLogger allows for printing messages in the console with nice formatting, metadata and call IDs for tracing async operations.
### permissions
The permissions module allows for checking if a user is authorized to perform an action on a mongoose model. Its rules are defined in `config/permissions.json`. Before using the `permissions.check` function, you need to call `permissions.init` to load and validate the JSON file.
If simple boolean checks are not enough, you can define your own checking functions with custom logic in `app/permissions/permissionFunction.js`.
The structure of `acl.json`:
```javascript
{
    /**
        VARIANT 1
        Name of the user's role
        @type: Object
    **/
    "admin": {
        /**
            Name of the mongoose model
            @type: String or Object
            If the value is a string, it must be an asterisk which indicates that every action is allowed 
            for the given role on this model
        **/
        "data.user": "*"
    },
    /**
        VARIANT 2
    **/
    "user": {
        "data.user": {
            /**
                Name of the CRUD action that will be performed on the model: add, get, update, delete
                @type: Boolean or String
                If the value is boolean, you either allow or disallow the user role to perform the given 
                action on `data.user`. 
                If you want to defined your own checking logic, you can use the string: "function".
                In this case, you need to define the corresponding function in
                `app/permissions/permissionFunctions.js`
            **/
            "add": false,
            "get": "function",
            "update": "function",
            "delete": "function"
        }
    }
}
```
The structure of `app/permissions/permissionFunction.js`:
```javascript
module.exports = {
    /**
        Name of the user's role
        @type: Object
    **/
    user: {
        /**
            Name of the mongoose model
            @type: Object
        **/
        'data.user': {
            /**
                Name of the CRUD action that will be performed on the model: add, get, update, delete
                @type: Function
                `data` can be anything you want - you pass it in the last optional argument to the 
                `permissions.check` function.
                `user` should be the user object extracted from an incoming request
            **/
            get: (data, user) => {
                return data.id == user._id;
            },
            update: (data, user) => {
                return data.id == user._id;
            },
            delete: (data, user) => {
                return data.id == user._id;
            }
        }
    }
};
```
### roomManager
This should be used to synchronize Socket.io rooms between threads. To achieve this, roomManager uses Redis as a common data store. Example usage:
```javascript
const manager = new RoomManager(1); //"1" is the redis database identifier
manager.init().then(() => {
    //Everything related to socket.io should be done after the initializing the manager
    io.of('/someNamespace').on('connection', (socket) => {
		//Joining the room in socket.io
        io.of('/someNamespace').adapter.remoteJoin(socket.id, 'roomName', async (error) => {
            //Joining the room in Room Manager (it's created automatically if it doesn't exist)
            await manager.addClient('someNamespace', 'roomName', socket.id);
			//Do something with the socket...
        });
    });
});
```
### router
Every route is defined in this module. New routes should be added to the `routes` object at the top. They are secured by JWT, [acl](https://github.com/TKasperczyk/mern-app-template#acl) and [permissions](https://github.com/TKasperczyk/mern-app-template#permissions). Every API function should be called through `performApiCall`. Errors can be handled by `handleError`. Example:
```javascript
'patch': {
    '/api/user/:id': (req, res) => {
        //We're checking if req.body contains the key: 'user'
        if (!h.checkMandatoryArgs({argMap: { user: true }, args: req.body})){
            return handleError(req, res, 'Incorrect or incomplete arguments');
        }
        /*The last argument (the object) is passed to your custom permissions validating 
        function defined in app/permissions/permissionFunction.js*/
        if (!permissions.check(
            req.user.role, 
            'data.user', 
            'update', 
            {data: {id: req.params.id}, user: req.user}
		) ){
            return handleError(req, res, 'You do not have sufficient permissions to perform this action');
        }
        /*The args parameter is destructured and passed to api.controllers['data.user'].update.
		Sending the response will be handled by performApiCall*/
        performApiCall({
            req, 
            res, 
            apiFunc: api.controllers['data.user'].update, 
            args: { id: req.params.id, user: req.body.user }
        });
    },
},
```
### scheduler
Allows for creating cron-like tasks that are executed periodically according to the configuration. Full documentation can be found [here](https://github.com/node-schedule). An example configuration is included in `config/config.sample.json`. New workers should be defined in the main `workers` object inside this module. It's important to account for the `currentlyRunning` flag as shown in the example. If the task is about to be executed while the worker function from the previous execution is still running, the current execution is canceled. 
### socket
Handles socket.io connections. In order to utilise the rooms functionality, you should use [roomManager](https://github.com/TKasperczyk/mern-app-template#roomManager) to keep them in sync between threads.