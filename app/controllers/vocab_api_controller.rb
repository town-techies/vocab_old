class VocabApiController < ApplicationController
  require 'net/http'
  require 'rubygems'
  require "open-uri"
  require 'json'
  def index
  end
  
	def getAllPuzzlelist
		if params["pid"] 
			 @puzzles = Puzzle.find(:all,:conditions => ["id=?",params["pid"]])
			
		else
			
			@puzzles = Puzzle.find(:all)
		end
		@result = []
		@puzzles.each do |puzzle|
		@data = {}
		@data["created_at"] = puzzle.created_at
		@data["description"] = puzzle.description
		@data["id"] = puzzle.id
		@data["paid"] = puzzle.paid
		@data["title"] = puzzle.title
		@data["updated_at"] = puzzle.updated_at
		@data["sound_url"] = (puzzle.sound.url == '/sounds/original/missing.png' ) ? 'No sound' : "http://#{request.host_with_port}#{puzzle.sound.url}"	
		@result << @data
		end

		respond_to do |format|
		  format.html # index.html.erb
		  format.json  { render :json => @result}
		end
	end  
  
  def getAllUserlist
    @result = []
    if !params[:id].nil?
      @user = User.find(params[:id])
      if @user.paid
        data = {}
        data["id"] = @user.id.to_s
        data["name"] = @user.name
        data["email"] = @user.email
        data["paid"] = "true"
        data["image_url"] = "http://#{request.host_with_port}/system/images/#{@user.id}/thumb/#{@user.image_file_name}"
        @result << data
      end 
    else 
      @users = User.find(:all,:conditions=>['paid =?',true])
      @users.each do |user|
        data = {}
        data = {}
        data["id"] = user.id
        data["name"] = user.name
        data["email"] = user.email
        data["paid"] = user.paid
        data["image_url"] = "http://#{request.host_with_port}/system/images/#{user.id}/thumb/#{user.image_file_name}"
        @result << data
      end
    end  
    master_val =  "#{params[:callback]}"+"(#{@result.to_json})"
    respond_to do |format|
      format.json  { render :json => master_val}
    end
  end
	
	def getAllQuestionlist
    @result = []
    if params["pid"]
          @questions = Question.find(:all,:conditions => ["puzzle_id=?",params["pid"]])
    else
  	  @questions = Question.find(:all)
    end
    if !@questions.blank? && !@questions.nil?
      @questions.each do |question|
        @data = {}
        if !question.answers.blank? && !question.answers.nil?
          arr = []
          question.answers.each do |answer|
            ans = {}
            ans["answer_id"] = answer.id
            ans["answer_title"] = answer.answer
	    ans["option"] = answer.true
            arr << ans 
            @data["question_puzzle_id"] = question.puzzle_id
            @data["question_word"] = question.word
            @data["question_id"] = question.id
            @data["question_part_of_speech"] = question.part_of_speech
            @data["question_example_sentence"] = question.example_sentence
            @data["question_root"] = question.root
            @data["question_root_language"] = question.root_language
            @data["question_etymology_meaning"] = question.etymology_meaning
            @data["question_actual_definition"] = question.actual_definition
            @data["answer"] = arr
          end
        end
        if @data != {}
          @result << @data
        end  
      end
    end
    master_val =  "#{params[:callback]}"+"(#{@result.to_json})"
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => master_val}
    end
	end  
  
	def getAllAnswerlist
	
	if params['aid']
	@answers = Answer.find(:all,:conditions => ["id = ?",params['aid']])
	else	
    	@answers = Answer.find(:all)
	end
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @answers}
    end
	end
	
	def addNewUserPuzzle_old
		@id = params["id"]
		@user_puzzle_details = UserPuzzle.find(:all,:conditions => ["device_id = ? and puzzle_id = ?  ",params["did"],params["pid"]])
		if @user_puzzle_details.size > 0
		
			UserPuzzle.where('device_id = ? and puzzle_id = ?', params[:did],params[:pid]).update_all(:score => params["score"],:correct_answer => params["cans"],:wronge_answer => params["wans"],:question_detail => params["qdetail"],:updated_at => Time.now)
			@recent_data = UserPuzzle.all.last(1).reverse
				data = {}
				data["Message"] = "User Puzzle Updated Successfully"
				data["last_record"] = @recent_data
				result = []
				result << data
				respond_to do |format|
					format.json  { render :json => data}
				end
		else
			@user_puzzle_details = UserPuzzle.new
			@user_puzzle_details.device_id = params["did"]
			@user_puzzle_details.puzzle_id = params["pid"]
			@user_puzzle_details.score = params["score"]
			@user_puzzle_details.correct_answer = params["cans"]
			@user_puzzle_details.wronge_answer = params["wans"]
			@user_puzzle_details.question_detail = params["qdetail"]
			if @user_puzzle_details.save
				data = {}
				@recent_data = UserPuzzle.all.last(1).reverse
				data["Message"] = "User Puzzle Added Successfully"
				data["last_record"] = @recent_data
				result = []
				result << data
				respond_to do |format|
					format.json  { render :json => result}
				end
			end

		end

	end  
  

	def addNewUserPuzzle
		@id = params["id"]
		#@user_puzzle_details = UserPuzzle.find(:all,:conditions => ["device_id = ? and puzzle_id = ?  ",params["did"],params["pid"]])
		#if @user_puzzle_details.size > 0
                if !params["id"].nil?
		
			UserPuzzle.where('id = ? ', params[:id]).update_all(:score => params["score"],:correct_answer => params["cans"],:wronge_answer => params["wans"],:question_detail => params["qdetail"],:updated_at => Time.now)
			@recent_data = UserPuzzle.find(params["id"])
				data = {}
				data["Message"] = "User Puzzle Updated Successfully"
				data["last_record"] = @recent_data.id
				result = []
				result << data
				respond_to do |format|
					format.json  { render :json => data}
				end
		else
			@user_puzzle_details = UserPuzzle.new
			@user_puzzle_details.device_id = params["did"]
			@user_puzzle_details.puzzle_id = params["pid"]
			@user_puzzle_details.score = params["score"]
			@user_puzzle_details.correct_answer = params["cans"]
			@user_puzzle_details.wronge_answer = params["wans"]
			@user_puzzle_details.question_detail = params["qdetail"]
			if @user_puzzle_details.save
				data = {}
				@recent_data = UserPuzzle.all.last(1).reverse
				data["Message"] = "User Puzzle Added Successfully"
				data["last_id"] = @recent_data[0].id
				result = []
				result << data
				respond_to do |format|
					format.json  { render :json => result}
				end
			end

		end

	end  





	def getUserPuzzlelist
	@pid = params["pid"];
	@uid = params['uid'];
	@id = params["id"];
    if(!params["pid"].nil? && !params["uid"].nil?) 
	if(!params["id"].nil?)
		@user_puzzles = UserPuzzle.find(:all,:conditions => ['device_id =? and puzzle_id = ? and id= ? ',@uid,@pid,@id])

	else
    		@user_puzzles = UserPuzzle.find(:all,:conditions => ['device_id =? and puzzle_id = ?',@uid,@pid])
	end
    else 
    @user_puzzles = UserPuzzle.find(:all,:conditions => ['device_id =? ',@uid])
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @user_puzzles}
    end
	end  

  def getAllQuestionwithAnswer
    @result = []
    if params["type"]
      case params["type"]
        when "12"
          @questions = Question.find(:all,:conditions => ['test_heading_id =?',1])
        when "24"
          @questions = Question.find(:all,:conditions => ['test_heading_id =?',2])
     end
    if !@questions.blank? && !@questions.nil?
     @questions.each do |question|
        master_hsh = {}
        @data = {}
        @ans = []
        if !question.answers.nil? && !question.answers.blank?
          question.answers.each do |answ| 
            arr = {}
            arr["title"] = answ.content
            arr["id"] = answ.id
            @ans << arr
          end
        end
        @data["title"] = question.content
        @data["answer"] = @ans
        @data["test-heading"] = question.test_heading.title
        @data["category"] = question.category.name
        @data["category_id"] = question.category_id
        @data["question_id"] = question.id
#        @data["ip"] = request.remote_ip
        master_hsh["q"] = @data
          @result << master_hsh
      end
    end     
   else
    @questions = Question.find(:all)  
    if !@questions.blank? && !@questions.nil?
     @questions.each do |question|
        master_hsh = {}
        @data = {}
        @ans = []
        if !question.answers.nil? && !question.answers.blank?
          question.answers.each do |answ| 
            arr = {}
            arr["title"] = answ.content
            arr["id"] = answ.id
            @ans << arr
          end
        end
        @data["title"] = question.content
        @data["answer"] = @ans
        @data["test-heading"] = question.test_heading.title
        @data["category"] = question.category.name
        @data["category_id"] = question.category_id
        @data["question_id"] = question.id
        master_hsh["q"] = @data
          @result << master_hsh
      end
    end     
   end
    master_val =  "#{params[:callback]}"+"(#{@result.to_json})"
    respond_to do |format|
      format.json  { render :json => master_val}
    end
  end

	def addNewUser
		@user = User.find(:all,:conditions => ["deviceId = ? ",params["did"]])
		#render :text => @user[0].paid.inspect and return false
		
		if @user.empty?
		#render :text => 'if' and return false
			@user = User.new
			@user.deviceId = params["did"]
			@user.device_name = params["dname"]
			@user.paid = (params["ustatus"] == "paid") ? true : false
			#render :text => @user.paid.inspect and return false
			if @user.save
				data = {}
				data["Message"] = "User Added Successfully"
				@users= User.find(:all)
				data["all_user"] = @users
				result = []
				result << data
				respond_to do |format|
					format.json  { render :json => result}
				end
			end

		else
		#render :text => 'else' and return false
		
			if @user[0].paid == false
				@ustatus = (params["ustatus"] == "paid") ? true : false
				User.where('deviceId = ? ', params[:did]).update_all(:device_name => params["dname"],:paid => @ustatus,:updated_at => Time.now)
				#User.update('deviceId = ?', params[:did].update(:device_name => params["dname"],:paid => @ustatus,:updated_at => Time.now))
				data = {}
				@users= User.find(:all)
				data["Message"] = "User Updated Successfully"
				data["all_users"] = @users
				result = []
				result << data
				
				respond_to do |format|
					format.json  { render :json => result}
				end
			else
				data = {}
				@users= User.find(:all)
				data["Message"] = "Nothing to do"
				data["all_users"] = @users
				result = []
				result << data
				respond_to do |format|
					format.json  { render :json => result}
				end
			
					
			end
		
		end
		

	end  

  
  
  def addNewDevice
    data = {}
    @result = []
    @user = User.new
    @user.name = "mobile devise"
    @user.password = "mobiledevise"
    @user.password_confirmation = "mobiledevise"
    @user.current_sign_in_ip = request.remote_ip
    @uniq_id = String.random_alphanumeric
    user = User.find_by_identity(@uniq_id)
    if user
      @uniq_id = String.random_alphanumeric
    end
    @user.email = "mobile#{@uniq_id}@devise.com"
    @user.identity = @uniq_id
    if @user.save
      data["devise_uniq_id"] = @user.identity
      data["ip"] = request.remote_ip
      data["created_at"] = @user.created_at
      @result << data
      master_val =  "#{params[:callback]}"+"(#{@result.to_json})"
      respond_to do |format|
        format.json  { render :json => master_val}
      end
    end  
  end
  
  def getTestResult
    @mbti_score = []
    @result = []
    @user_answers = JSON.parse(params["answeres"].gsub('/\/',''))
    @category = {}
    @user_answers.each do |question_id,answer_id|
      data = {}
      question = Question.find(question_id)
      if @category.has_key?("#{question.category_id}")
        @category["#{question.category_id}"][question_id] = answer_id
      else
        @category["#{question.category_id}"] = {"#{question_id}" => answer_id}
      end
    end
    @category.each do |categoryId,q_With_answer|
      @n_h =  {}
      q_With_answer.each do |questionId,answerId|
        answer = Answer.find(answerId)
        mbti_score = answer.mbti_score.title
        if @n_h.has_key?(mbti_score)
          @n_h[mbti_score]  = @n_h[mbti_score].to_i+1
        else
          @n_h[mbti_score] = 1   
        end
      end
      sort_val = @n_h.values.sort[-1]
      @n_h.each do |k,v|
          if v == sort_val
           @mbti_score << k 
          end 
      end

    end
    @mbti_result = {}
    @mbti_combinations = MbtiCombinationProfile.find(:all)
    main_result = []
    @mbti_combinations.each do |mbti_combination|
      score_one = mbti_combination.mbti_score.title
      @score_result = []
      @score_result << score_one 
      score_two =  	mbti_combination.mbti_score_one.title
      @score_result << score_two 

      score_three =  	mbti_combination.mbti_score_two.title
      @score_result << score_three 

      score_four =  	mbti_combination.mbti_score_three.title
      @score_result << score_four
      if @score_result.join('') == @mbti_score.join('') 
         @mbti_score_detail = mbti_combination.mbti_detail           
      else
        @mbti_score_detail = "No Such Combination found need to add At admin side"
      end
    end
    @mbti_result["mbti_score"] =  @mbti_score.join('')
    @mbti_result["mbti_detail"] = @mbti_score_detail
    @result << @user_answers
    @result << @mbti_result
    master_val =  "#{params[:callback]}"+"(#{@result.to_json})"
    respond_to do |format|
      format.json  { render :json => master_val}
    end
  end
  

  def getUserslist
    @result = []
    @user_details = UserDetail.find(:all,:conditions=>['device_id =?',params["device_id"]])
    @user_details.each do |user_detail|
      data = {}
      data["userProfileId"] = user_detail.id
      data["name"] = user_detail.name
      data["email"] = user_detail.email
      data["mbti_score"] = user_detail.mbti_result
      @mbti_combinations = MbtiCombinationProfile.find(:all)
      @mbti_combinations.each do |mbti_combination|
        score_one = mbti_combination.mbti_score.title
        @score_result = []
        @score_result << score_one 
        score_two =  	mbti_combination.mbti_score_one.title
        @score_result << score_two 

        score_three =  	mbti_combination.mbti_score_two.title
        @score_result << score_three 

        score_four =  	mbti_combination.mbti_score_three.title
        @score_result << score_four
        if @score_result.join('') == user_detail.mbti_result 
           data["mbti_score_detail"] =  mbti_combination.mbti_detail
        end
      end
      @result << data  
    end
    master_val =  "#{params[:callback]}"+"(#{@result.to_json})"
    respond_to do |format|
      format.json  { render :json => master_val}
    end
  end
  
  def getUserProfile
      @result = []
      if !params["userProfileId"].nil?
        @user_detail = UserDetail.find(params["userProfileId"])
        if !@user_detail.blank? && !@user_detail.nil?
          data = {}
          data["name"] = @user_detail.name    
          data["email"] = @user_detail.email
          data["mbti_result"] = @user_detail.mbti_result
          @mbti_combinations = MbtiCombinationProfile.find(:all)
          @mbti_combinations.each do |mbti_combination|
            score_one = mbti_combination.mbti_score.title
            @score_result = []
            @score_result << score_one 
            score_two =  	mbti_combination.mbti_score_one.title
            @score_result << score_two 

            score_three =  	mbti_combination.mbti_score_two.title
            @score_result << score_three 

            score_four =  	mbti_combination.mbti_score_three.title
            @score_result << score_four
            if @score_result.join('') == @user_detail.mbti_result 
               data["mbti_score_detail"] =  mbti_combination.mbti_detail
            end
          end
          @user_answers = JSON.parse(@user_detail.user_answer)
          user_ans_detail = []
          @user_answers.each do |question_id,answer_id|
            user_ans = {}   
            question = Question.find(question_id)
            user_ans["question"] = question.content
            answer = Answer.find(answer_id)
            user_ans["answer"] = answer.content
            user_ans_detail << user_ans
          end
          master_sh = {}
          master_sh["questionWithAnswer"] =  user_ans_detail
          
          data = data.merge(master_sh)
        @result << data
      end 
    else 
      @result = [{}]  
    end
    master_val =  "#{params[:callback]}"+"(#{@result.to_json})"
    respond_to do |format|
      format.json  { render :json => master_val}
    end
  end
  
  
  def delUserProfile
    user_detail = UserDetail.find(params["userProfileId"])
    user_detail.destroy
    hs = {}
    hs["message"] = "User Profile Deleted Successfully"
    master_val = []
    master_val << hs
    respond_to do |format|
       format.json  { render :json => master_val} 
    end
  end
  
  def getMbtiScoreDetail
      @mbti_combinations = MbtiCombinationProfile.find(:all)
      @result = []
      @mbti_combinations.each do |mbti_combination|
        data = {}
        score_one = mbti_combination.mbti_score.title
        @score_result = []
        @score_result << score_one 
        score_two =  	mbti_combination.mbti_score_one.title
        @score_result << score_two 

        score_three =  	mbti_combination.mbti_score_two.title
        @score_result << score_three 

        score_four =  	mbti_combination.mbti_score_three.title
        @score_result << score_four
        data["title"] = @score_result.join('')
        data["mbti_detail"] =  mbti_combination.mbti_detail
        if params["mbti_score"]
          @single_mbti = {}
          if @score_result.join('') == params["mbti_score"]
            @single_mbti["title"] = @score_result.join('')
            @single_mbti["mbti_detail"] = mbti_combination.mbti_detail
          end 
        end
        if params["mbti_score"]
           if @single_mbti != {} 
             @result <<  @single_mbti
            end
        else
          @result << data
        end 
      end
    master_val =  "#{params[:callback]}"+"(#{@result.to_json})"
    respond_to do |format|
      format.json  { render :json => master_val}
    end
  end
    
end

#   def getUserProfile
#     if !params[:userid].nil?
#        @user_profiles = UsersProfile.find(:all,:conditions => ['user_id =?',params[:userid]])
#        if !@user_profiles.blank? && !@user_profiles.nil?
#          master_hsh = {}
#          @result = []
#          @user_profiles.each do |user_profile|
#            @data = {}
#            arr = {}
#            @ans = []
#           @qus = []
#            @mbti = []
#            arr["title"] = user_profile.question.content
#            arr["id"] = user_profile.question_id
#           @ans << arr
#            arr = {}
#            arr["title"] = user_profile.answer.content
#           arr["id"] = user_profile.answer_id
#           @qus << arr
#            arr = {}
 #           arr["score"] = user_profile.mbti_score.title
 #           arr["score_id"] = user_profile.mbti_score_id
 #           @mbti << arr
 #           @data["question"] = @qus
 #           @data["answer"] = @ans
  #          @data["name"] = user_profile.user.name
   #         @data["mbti_score"] = @mbti
    #        master_hsh["user_profile"] = @data
    #        @result << master_hsh
     #     end
     #   end
    #else
    #  @result = []         
   #end
   # master_val =  "#{params[:callback]}"+"(#{@result.to_json})"
   # respond_to do |format|
   #   format.json  { render :json => master_val}
   # end
  #end