### 0.5.16

- Add Balancing Entry Detail rows in order to construct a Balanced ACH file
  (@samgranieri)

### 0.5.4

- Increment batch numbers if not manually set.

### 0.5.1

- Parsing sets BatchHeader#full_company_identification for company
  identifications that are not EINs.
- Setting a field with a default value to nil no longer raises a validation
  error.

### 0.5.0

* Add ACH::InvalidError and use instead of RuntimeError for validation errors.
* Support leading characters for `immediate_origin` (@phlipper)

### 0.4.11

* Add support for records to be case sensitive (@binarypaladin)

### 0.4.10

* Add calculator for valid effective date (@aripollak)

### 0.4.9

* Allow zero filled settlement_date (@rawsyntax)
* Fix trace number parsing (@tubergen)

### 0.4.8

* Handle encoding issues with fixed-length records (@terryjray)
* Improve addenda support

### 0.4.7

* Remove company_identification_code_designator and extend to
  company_identification field to 10 digits.
