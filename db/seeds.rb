require "ffaker"

puts "Create companies"
companies = {
  "FPT software": "Hoang Nam Tien",
  "BraveBits": "Alex Ferguson",
  "VC Corp": "Vuong Vu Thang",
  "Ipcoms": "Vu Minh Tuan"
}

default_user = User.create! name: "Hoang Thi Nhung",
  email: "hoang.thi.nhung@framgia.com",
  password: "123456",
  role: "employer"

default_company = Company.create! name: "Framgia VietNam",
  introduction: "ARE YOU READY TO MAKE IT AWESOME WITH US?",
  website: FFaker::Internet.domain_name,
  founder: "Kobayashi Taihei",
  company_size: 100, founder_on: FFaker::Time.datetime,
  creator_id: default_user.id

InfoUser.create! user_id: default_user.id,
  introduction: "hello world, i am developer",
  address: "Ha Noi, Viet Nam",
  phone: "123456789"

companies.each do |name, founder|
  Company.create! name: name,
    introduction: "ARE YOU READY TO MAKE IT AWESOME WITH US?",
    website: FFaker::Internet.domain_name, founder: founder,
    company_size: 100, founder_on: FFaker::Time.datetime
end

puts "Create users"
users = {
  "do.ha.long@framgia.com": "Do Ha Long",
  "luu.thi.thom@framgia.com": "Luu Thi Thom",
  "thuy.viet.quoc@framgia.com": "Thuy Viet Quoc",
  "tran.anh.vu@fsramgia.com": "Tran Anh Vu",
  "le.quang.canh@sframgia.com": "Le Quang Anh",
  "user@gmail.com": "User",
  "ttkt1994@gmail.com": "User",
}

users.each do |email, name|
  user = User.create! name: name, email: email, password: "123456"
  InfoUser.create! user_id: user.id,
    introduction: "hello world, i am developer",
    address: "Da Nang, Viet Nam",
    phone: "123456789"
end

trainees = {
  "do.van.nam@framgia.com": "Do Van Nam",
  "nguyen.ha.phan@framgia.com": "Nguyen Ha Phan",
  "nguyen.ngoc.thinh@framgia.com": "Nguyen Ngoc Thinh",
  "tran.xuan.nam@framgia.com": "Tran Xuan Nam",
  "chu.kim.thang@framgia.com": "Chu Kim Thang",
  "bui.khanh.huyen@framgia.com": "Bui Khanh Huyen",
  "sonnguyenngoc1604@gmail.com": "Nguyen Ngoc Son"
}

trainees.each do |email, name|
  trainee = User.create! name: name, email: email, password: "123456",
    role: "trainee"
  InfoUser.create! user_id: trainee.id,
    introduction: "hello world, i am developer",
    address: "Da Nang, Viet Nam",
    phone: "123456789"
end

edu_admin = User.create! name: "Education admin",
  password: "123456",
  email: "admin.education@framgia.com"
InfoUser.create! user_id: edu_admin.id, introduction: "hello world, i am developer",
  address: "Da Nang, Viet Nam", phone: "123456789"

user = User.create! name: "Adminprp",
  email: "admin@gmail.com",
  password: "123456",
  role: "admin"
InfoUser.create! user_id: user.id, introduction: "hello world, i am developer",
  address: "Da Nang, Viet Nam", phone: "123456789"

puts "Create Candidate"
users = User.limit(20).pluck(:id)
users.each do |candidate|
  jobs = Job.order("Random()").limit(20).pluck :id
  interested_in = [:have_a_chat, :work_together, :opportunity].shuffle.first
  process = [:apply, :fail_test, :joined , :pass_test, :wait_test].shuffle.first
  jobs.each do |job|
    Candidate.create! user_id: candidate, job_id: job,
      interested_in: interested_in, process: process
  end
end

puts "Update counter cache candidate"
Job.all.each do |job|
  Job.update_counters job.id, candidates_count: job.candidates.length
end

puts "Create employee of company"
User.all.each do |user|
  Employee.create! user_id: user.id, company_id: 1,
    description: FFaker::Lorem.sentence
end

puts "Create addresses of company"
Company.all.each do |company|
  Address.create! company_id: company.id,
    address: FFaker::Address.city,
    head_office: 1
end

puts "Create skills"
6.times do
  Skill.create name: FFaker::Skill.tech_skill
end

puts "Assign skill to user"
User.all.each do |user|
  skills = Skill.order("Random()").limit(2).pluck(:id)
  skills.each do |skill|
    SkillUser.create! user_id: user.id, skill_id: skill,
    years: rand(1..3)
  end
end

puts "Create skills are required by jobs"
Job.all.each do |job|
  skills = Skill.order("Random()").limit(4).pluck(:id)
  skills.each do |skill|
    JobSkill.create! job_id: job.id, skill_id: skill
  end
end

puts "create default course of user"
user = User.create! email: "tran.tuan.nghia@framgia.com",
  name: "Tran Tuan Nghia",
  password: "123456"

InfoUser.create! user_id: user.id, introduction: "humman development",
  ambition: "become to rich man", quote: "human", phone: "123456789",
  birthday: "1996-11-05", occupation: "student", gender: "male"

programming_language = ProgrammingLanguage.create name: "ruby"

courses = [
  {
    name: "[KN] Ruby on Rails 03/10/2016", start_date: "2016-10-03",
    end_date: "2016-11-11", status: "finished",
    description:  "training ruby in two months"
  },
  {
    name: "PHP 03/11/2016", start_date: "2016-11-03",
    end_date: "2016-11-05", status: "finished",
    description:  "training PHP in two months"
  }
]
courses.each do |course|
  course_create = Course.create! name: course[:name],
    start_date: course[:start_date],
    end_date: course[:end_date],
    status: course[:status],
    programming_language_id: programming_language.id,
    description: course[:description]

  UserCourse.create! user_id: user.id, course_id: course_create.id
end

puts "create default subject of user"
subjects = [
  {
    name: "Git Tutorial",
    subject_description: "Start Git for your project today.\r\n",
    subject_content: "<p>Get an introduction to github, code version management</p>\r\n",
    status: "finished", start_date: "2016-10-03", end_date: "2016-10-05"
  },
  {
    name: "Ruby's Project 1",
    subject_description: "Start Project 1 for Ruby on Rails today.\r\n",
    subject_content: "<p>Get an introduction to redmine, requirement, design database</p>\r\n", status: "finished", start_date: "2016-11-22", end_date: "2017-02-08"
  },
  {
    name: "Ruby's Project 2",
    subject_description: "Start Project 2 for Ruby on Rails today.\r\n",
    subject_content: "<p>Get an introduction to redmine, requirement, design database</p>\r\n",
    status: "finished",
    start_date: "2017-02-08", end_date: "2017-03-08"
  },
  {
    name: "Ruby on Rails Tutorial Book",
    subject_description: "Learn the basic building blocks of Ruby, all in the browser.\r\n",
    subject_content: "<p>Get an introduction to numbers, Strings, properties, and methods,&nbsp; Learn about conversions, arrays, variables, and more methods</p>\r\n",
    status: "finished", start_date: "2016-10-05", end_date: "2016-12-15"
  }
]
course = Course.find_by name: "[KN] Ruby on Rails 03/10/2016"
user = User.find_by email: "tran.tuan.nghia@framgia.com"

subjects.each do |subject|
  subject_created = Subject.create! name: subject[:name], description: subject[:subject_description]

  UserCourseSubject.create! user_id: user.id, course_id: course.id,
    subject_id: subject_created.id, start_date: subject[:start_date],
    end_date: subject[:end_date], status: subject[:status],
    content: "Basic for work!"
end

puts "create default subject of user"
 tasks = [
  {
    user_email: "tran.tuan.nghia@framgia.com",
    subject_name: "Git Tutorial",
    course_name: "[KN] Ruby on Rails 03/10/2016",
    data: [
      {
        name: "Getting Started", status: "in_progress",
        content: "Get an introduction to project git",
        task_type: "assignments"
      },
      {
        name: "Git Branching", status: "in_progress",
        content: "Get an introduction to project git",
        task_type: "assignments"
      },
      {
        name: "Distributed Git", status: "in_progress",
        content: "Get an introduction to project git",
        task_type: "assignments"
      },
      {
        name: "GitHub", status: "init",
        content: "Get an introduction to project git",
        task_type: "assignments"
      },
      {
        name: "Git Tools", status: "init",
        content: "Get an introduction to project git",
        task_type: "assignments"
      },
      {
        name: "Customizing Git", status: "init",
        content: "Get an introduction to project git",
        task_type: "assignments"
      }
    ]
  },
  {
    user_email: "tran.tuan.nghia@framgia.com", subject_name: "Ruby's Project 1",
    course_name: "[KN] Ruby on Rails 03/10/2016",
    data: [
      {
        name: "Requirement understanding", status: "init",
        content: "Get an introduction to project understanding",
        task_type: "assignments"
      },
      {
        name: "Design Database", status: "in_progress",
        content: "Start design database", task_type: "assignments"
      }
    ]
  }
]

tasks.each do |task|
  user = User.find_by email: task[:user_email]
  subject = Subject.find_by name: task[:subject_name]
  course = Course.find_by name: task[:course_name]

  task[:data].each do |data|
    task_created = Task.create! name: data[:name],
      subject_id: subject.id, task_type: data[:task_type],
      description: data[:content]

    UserTask.create! user_id: user.id,
      task_id: task_created.id, subject_id: subject.id,
      course_id: course.id,
      status: data[:status]
  end
end
