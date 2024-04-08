# README

implementation for a job application challenge:  https://github.com/segdev-tecnologia/vagas/tree/main/backend/desafio2


* dependencies
```
ruby 3.2.2
postgres
```

* Configuration
make sure the postgress username and password is both
set to "postgres" or make the necessary changes to database.yml

* Test
example requests can be found in the Insomnia export json in the root folder of this repo.

there is an hosted instance of this application running on https://seguradora-api.cap.greyrepo.xyz/

curl command to test the application:
```bash
curl --request POST \
  --url https://seguradora-api.cap.greyrepo.xyz/risk_profile/plan_suggestion \
  --header 'Content-Type: application/json' \
  --data '{
	"insured": {
		"age": 53,
		"dependents": 6,
		"house": {},
		"income": 10000,
		"marital_status": "married",
		"risk_questions": [1, 1, 1],
		"vehicle": {}
	}
}'
```

```bash
curl --request POST \
  --url https://seguradora-api.cap.greyrepo.xyz/risk_profile/plan_suggestion \
  --header 'Content-Type: application/json' \
  --data '{
	"insured": {
		"age": 53,
		"dependents": 6,
		"house": {"ownership_status": "rented"},
		"income": 10000,
		"marital_status": "married",
		"risk_questions": [1, 1, 1],
		"vehicle": {"year": 2022}
	}
}'
```
