class ChangeBasicModelInheritance < Mongoid::Migration
  def self.up
    # #get the mongo database instance from the Mongoid::Document
    mongo_db = User.db

    # #query the collection for the fields needed for the migration
    models = mongo_db.collection("generic_models").find()

    models.each do |model_hash|
      mongo_db.collection("quizzes").insert(model_hash)
    end
    
    mongo_db.collection("generic_models").drop
  end

  def self.down
    mongo_db = User.db

    # #query the collection for the fields needed for the migration
    models = mongo_db.collection("quizzes").find()

    models.each do |model_hash|
      mongo_db.collection("generic_models").insert(model_hash)
    end
  end
end