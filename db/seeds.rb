# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
case Rails.env

  when 'development'

    puts 'Searching for random names on the Internet...'

    response = ''
    5.times do # retry up to 5 times
      begin
        response = Net::HTTP.get('random-name-generator.info', '/random/?n=100&g=1&st=2')
        break # it worked, break out of the loop
      rescue StandardError => e
        logger.info e
        sleep 5
      end
    end

    names = Array(Nokogiri::HTML(response).at('ol')&.search('li')).map{|li| li.text.strip.gsub(/\t/, '') }

    raise 'random-name-generator.info is currently unavailable, please retry later' if names.empty?

    puts 'Creating some users...'

    user_emails = User.pluck(:email)

    names.each_with_index do |name, i|
      ApplicationHelper.puts_progression('User creation', (100 * i.to_f / names.size.to_f).to_i)
      email =  name.tr(' ', '.') + "@demo.com"
      next if user_emails.include?(email)
      next if name.size < 8
      user = User.new(
        email:                 email,
        password:              name,
        password_confirmation: name,
        first_name:            name.split.first,
        last_name:             name.split.last,
        age:                   Random.rand(18..88)
      )
      raise("Can't create user #{name}: #{user.errors.full_messages.join(', ')}") unless user.save
    end

    puts "#{User.count} users created!"

    puts 'Creating some surveys...'

    questions = YAML.load_file(Rails.root.join('db', 'migrate', 'questions.yml'))
    questions.each_with_index do |question, i|
      ApplicationHelper.puts_progression('Question creation', (100 * i.to_f / questions.size.to_f).to_i)
      survey = Survey.find_or_create_by(
        is_active: ApplicationHelper.rnd_yes_no,
        question: question,
        surveyor: User.order("RANDOM()").first
      )
      raise("Can't create survey #{question}: #{survey.errors.full_messages.join(', ')}") unless survey.valid?
    end

    puts "#{Survey.count} surveys created! "

    puts 'Creating some answers...'

    surveys_count = Survey.count
    Survey.find_in_batches(batch_size: 10).each_with_index do |surveys, i|
      ApplicationHelper.puts_progression('Answer creation', (1000 * i.to_f / surveys_count.to_f).to_i)
      surveys.each do |survey|
        answers = Answer.create(rand(50).times.map{
          {
            survey: survey,
            respondent: User.order("RANDOM()").first,
            yes_no: ApplicationHelper.rnd_yes_no
          }
        })
        raise("Can't create this batch of answers: #{answers.map{|answer| answer.errors.full_messages}.flatten.uniq.join(', ')}") unless answers.all?(&:valid?)
      end
    end

    puts "#{Answer.count} answers created!"

    puts 'Denormalizing the closed surveys...'

    closed_surveys_count = Survey.pending_denormalization.count
    Survey.pending_denormalization.find_in_batches(batch_size: 10).each_with_index do |surveys, i|
      ApplicationHelper.puts_progression('Answer creation', (1000 * i.to_f / closed_surveys_count.to_f).to_i)
      surveys.each(&:denormalize)
    end

    puts "#{closed_surveys_count} closed surveys denormalized!"

end
