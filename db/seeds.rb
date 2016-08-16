# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.where(email: 'bfox@opuslogica.com').first_or_create(password: 'idtmp2tv', password_confirmation: 'idtmp2tv')

survey_groups = [
  { name: "Health Baseline",
    questions: [
      { name: "Codename", type: "String", selection_type: "Fixed", instructions: "Your codename is chosen for you!" },
      { name: "Birthdate", type: "Date", selection_type: "Date", instructions: "Your date of birth helps us to understand your problems better" },
      { name: "Gender at Birth", type: "String", selection_type: "Pick One", options: ["Male", "Female"], instructions: "This is unrelated to your current gender" }
    ]},
  { name: "Illness & Symptoms",
    questions: [
      { name: "I'm suffering from", type: "String", selection_type: "Pick Many With Other",
        options: [
          "Cancer/Leukimia",
          "Skin Irritations/Rashes/Lesions",
          "Eye Irritation/Vision Issues",
          "Upper Respiratory Issues (nose, sinus, throat)",
          "Lower Respiratory Issues (difficulty breathing)",
          "Kidney/Liver/Pancreas Issues",
          "Neurological issues",
          "Psychological Issues/Depression",
          "Gastrointestinal issues / nausea",
          "Cardiovascular issues",
          "Headaches / dizziness",
          "Genealogical issues",
          "Fatigue",
          "Muscular / skeletal issues",
          "Balding / hair loss" ],
        instructions: "Select all that apply, including pre-existing conditions" },
      { name: "Your role(s) during the spill", type: "String", selection_type: "Pick Many With Other",
        options: [
          "Community member",
          "Cleanup worker",
          "BP employee",
          "Volunteer",
          "Government employee",
          "Contractor",
          "Fisherman",
          "Boat captain / crew" ],
        instructions: "Select all that apply" }
    ]},
  { name: "Locations",
    questions: [
      { name: "Location where you were exposed", type: "String", selection_type: "Location", instructions: "Enter zip code, address, or other location information" },
      { name: "Location where you live now", type: "String", selection_type: "Location", instructions: "Enter zip code, address, or other location information" }
    ]}
];

survey_groups.each_with_index do |group, gi|
  group[:position] = gi + 1
  ar_group = SurveyGroup.where(name: group[:name]).first_or_create
  ar_group.update_attributes(instructions: group[:instructions], position: group[:position])
  ar_group.save
  group[:questions].each_with_index do |question, qi|
    question[:position] = qi + 1
    ar_question = SurveyQuestion.where(name: question[:name]).first_or_create
    ar_question.update_attributes(survey_group: ar_group, instructions: question[:instructions], type: question[:type],
                                  selection_type: question[:selection_type], position: question[:position])
    ar_question.save
    if question[:options]
      question[:options].each_with_index do |opttext, oi|
        option = { name: opttext, position: oi + 1 }
        ar_option = QuestionOption.where(name: option[:name]).first_or_create
        ar_option.update_attributes(survey_question: ar_question, name: option[:name], position: option[:position])
        ar_option.save
      end
    end
  end
end
