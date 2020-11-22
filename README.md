# Test Overview

This test is to read a piece of code and display an understanding of it through words & specs.

## Description

The code we're looking at is `app/services/base_service.rb`.

In Jenfi, Service Objects hold all the key business logic and this file underpins it all. We're hoping you can tell us how this works.

## Supporting Materials

- `Account` & `Company` ActiveRecord objects are available.
- Rspec, FactoryBot, Faker
# Test Instruction

1. Read the code.
1. Run the [Startup Instructions](#instructions).
1. Write specs to show understanding.
    - Add specs to `specs/services/base_service_spec.rb`.
1. Writeup of quick/dirty thoughts in the [Your Thoughts](#thoughts) section.
    - Bullet points
    - You can tell me this code sucks, but you have to tell me why.
1. When you're finished - zip up the directory, email it.
1. Issues? Reach out!

## What NOT to do

- Don't modify/improve anything other than the spec.
    - If you have improvements, write them below.
- Don't only write specs. Leave time for your thoughts.
- Don't get stuck, it's more important to write & create specs for what you understand.
    - This thing is like an onion.
    - Each layer gets more difficult to reason about.
- Don't spend more than 2 hours on this.
# Some Questions to Guide

1. What is the entry point?
- call and call! are the entry point
2. How is this called?
```
class CompanyCreator
  include BaseService

  def call(name:)
    company = Company.new(name: name)
     if company.save
       context.merge(compay: company)
     else
       context.fail!(errors: company.errors.full_messages.to_sentence)
    end
  end
end

result = CompanyCreator.call(name: 'Jenfi')
if result.success?
 render somthing
else
 render json: {errors: result.errors}
end
```
3. What can the BaseService do?
The base service has been using Gourmet Service Objects. the base service provides a common interface for running user interactions.


# Startup Instructions<a name="instructions"></a>

No requirement to use docker - just be able to run `rspec .`

1. Install Docker
1. run `docker-compose up --build --remove-orphans`
1. run `docker exec -it exam-short-base-service_app_1 /bin/bash`
1. run `rails db:create && rails db:migrate`
1. run `rspec .`

# Your Thoughts <a name="thoughts"></a>

- I wrote 90% test coverage and there is have some suck codes. In create company migration added null: false to name but it missed to add validation to company because of handle errors by active records
- the `BaseService` is like <a href="https://github.com/collectiveidea/interactor">interactor gem</a> and it helps to avoid fat-controller or fat-model and clean up codes, but the service objects are not good idea because service objects throw out the fundamental advantages of object-oriented programming</b>.  
- I prefer using concerns and POROs instead of service objects encourages better interfaces, proper separation of concerns, sound use of OOP principles, and easier code comprehension and service object is not easy to use and 
didn't have good interface and I'd like to use instance method and callback and control input by active record validation. 