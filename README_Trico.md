This plugin sends messages to the message server using RabbitMQ (Bunny). The idea is that when a record is changed in ASpace, it triggers the indexer. We have changed the indexer so that it will send a message to the message server. We can then consume those messages from the message server and create workflows based from the messages.

One thing to consider is that if we reindex everything, then thousands of messages will be sent to the messaging server. Perhaps there is a way to turn off the messages when something is getting reindexed. Perhaps we can just turn off the plugin in the config file before reindexing... we would just need to remember to do that.

