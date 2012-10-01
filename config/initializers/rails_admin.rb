# RailsAdmin config file. Generated on February 24, 2012 09:24
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|

  # If your default_local is different from :en, uncomment the following 2 lines and set your default locale here:
  # require 'i18n'
  # I18n.default_locale = :de

  config.current_user_method { current_admin } # auto-generated

  # If you want to track changes on your models:
  # config.audit_with :history, Admin

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, Admin

  # Set the admin name here (optional second array element will appear in a beautiful RailsAdmin red ©)
  config.main_app_name = ['Vocab', 'Tales','Sat']
  # or for a dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  config.model Admin do
    weight -12
  end
  config.model User do
    weight -11
  end
  #config.model VocabCombinationProfile do
  #  weight -10
  #end

  config.model UserDetail do
    label "User profile"
    weight -9
  end
  
  #config.model Category do
  #  weight -8
  #end
  config.model Puzzle do
    weight -8
  end
  config.model Question do
    weight -7
  end

  config.model Answer do
    weight -6
  end
  config.model UserPuzzle do
    weight -5
  end
  #config.model Setting do
   # weight -4
  #end

  #config.model Language do
  #  weight -5
 # end
 # config.model QuestionType do
   # weight -4
  #end

  #config.model VocabScore do
   # visible false
 # end

  #config.model TestHeading do
  #  visible false
  #end

 # config.model Setting do
 #   weight -1
 # end
  
  #config.model VocabScoreOne do
   # visible false
 # end

  #config.model VocabScoreTwo do
 #   visible false
 # end

 # config.model VocabScoreThree do
 #   visible false
  #end
  
 # config.model Puzzle do
  #  visible true
 # end

  #  ==> Global show view settings
  # Display empty fields in show views
  # config.compact_show_view = false

  #  ==> Global list view settings
  # Number of default rows per-page:
  # config.default_items_per_page = 20

  #  ==> Included models
  # Add all excluded models here:
   #config.excluded_models = [Quiz,SubmittedAnswer,SubmittedQuiz ]
  # Add models here if you want to go 'whitelist mode':
   #config.included_models = [UserPuzzle,Puzzle,Answer, Question, Category,Language,Setting,User, Admin,VocabCombinationProfile,VocabScore,TestHeading,VocabScoreOne,VocabScoreTwo,VocabScoreThree,UserDetail]
   config.included_models = [User, Admin, Puzzle, Question, Answer, UserPuzzle]

  # Application wide tried label methods for models' instances
  # config.label_methods << :description # Default is [:name, :title]
  config.model Admin do
    list do
      #field :name
      field :email
#      field :created_at
#      field :updated_at
      field :sign_in_count					
    end
   edit do
     field :name,:string
     field :email,:string
	  field :password,:password
	  field :password_confirmation,:password
    end
  end

  config.model User do
   list do
		field :deviceId
		field :device_name
		field :paid
		field :updated_at
  end
   edit do
		field :deviceId,:string
		field :device_name,:string
		field :paid, :boolean
    end
    show do
      exclude_fields :users_profiles      
    end
    
  end
  
  #config.model Category do
  # list do
#		field :name
#		field :description
#		field :status
  #  end
 #  edit do
#		field :name,:string
#		field :description,:text
#		field :status,:boolean
  #  end

 # end
  
    
  #config.model VocabCombinationProfile do
  #  list do
   #   field :vocab_score
    #  field :vocab_detail
     # field :status
    #end
    #edit do 
     # field :vocab_score
      #field :vocab_score_one
     # field :vocab_score_two
     # field :vocab_score_three
     # field :vocab_detail
      #field :status
      
    #end
  #end 


  #config.model VocabScore do
   # list do
    #  field :title
    #end
    #edit do
     # field :title ,:string  
    #end
  #end 


  #config.model UsersProfile do
    #list do
   #   field :user
   #   field :question
  #    field :answer
   #   field :mbti_score
  #  end
 # end 

  #config.model Language do
  #  list do
   #   field :language_title
    #  field :language_code
     # field :status
    #end
  #end 



  #config.model TestHeading do
   # list do
    #  field :title
     # field :questions
    #end
  #end 

  config.model UserDetail do 
    list do 
#      field :user
      field :name
      field :email
      field :mbti_result
      
    end
  end

  #  ==> Global models configuration
  # config.models do
  #   # Configuration here will affect all included models in all scopes, handle with care!
  #
  #   list do
  #     # Configuration here will affect all included models in list sections (same for show, export, edit, update, create)
  #
  #     fields_of_type :date do
  #       # Configuration here will affect all date fields, in the list section, for all included models. See README for a comprehensive type list.
  #     end
  #   end
  # end
  #
  #  ==> Model specific configuration
  # Keep in mind that *all* configuration blocks are optional.
  # RailsAdmin will try his best to provide the best defaults for each section, for each field.
  # Try to override as few things as possible, in the most generic way. Try to avoid setting labels for models and attributes, use ActiveRecord I18n API instead.
  # Less code is better code!
  # config.model MyModel do
  #   # Cross-section field configuration
  #   object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #   label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #   label_plural 'My models'      # Same, plural
  #   weight -1                     # Navigation priority. Bigger is higher.
  #   parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #   navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  #   # Section specific configuration:
  #   list do
  #     filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #     items_per_page 100    # Override default_items_per_page
  #     sort_by :id           # Sort column (default is primary key)
  #     sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     # Here goes the fields configuration for the list view
  #   end
  # end

  # Your model's configuration, to help you get started:

  # All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible. (visible(true))

  config.model Answer do
    list do 
      #field :question
      field :answer
      field :true
	end
    edit do 
      exclude_fields :users_profiles    
    end
    show do
      exclude_fields :users_profiles      
    end
    object_label_method do
      :answer_label_method
    end
  end

  config.model Question do

    list do
      field :word
      field :part_of_speech
      field :root
     # field :category
    end
    edit do
      exclude_fields :users_profiles
    end
    object_label_method do
      :question_label_method
    end
    show do
      exclude_fields :users_profiles      
    end
  end
  
  config.model Puzzle do
   list do
		field :title
		#field :description
		field :paid
		field :sound, :paperclip
    end
 

  end


  def question_label_method
    "#{self.word}"
  end

  def answer_label_method
    "#{self.answer}"
  end
  
  def vocab_combination_profile_label_method
    "#{self.content}"
  end
end

