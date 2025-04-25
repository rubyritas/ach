### v0.6.5

- Fix bug in parse_descriptive_date method in ach_file.rb by @jkaufman638 in #74

### v0.6.4

- Fix keyword argument 2.7 by @lorman in #71
- fix: use federalreservebanks holiday definition for ACH files by @kapil2004 in #73

### v0.6.3

- ACH::StringFormattingHelper - add some specs for more context if the current code needs further work
- Fix ruby keyword argument deprecation

### v0.6.2

- Add README comment about File Creation Date timezones in file header by @zcotter in #63
- Fix reading files with SD1700 in company descriptive date field by @henriquegasques in #66
- Fix formatting of the #company_descriptive_date filed by @chubchenko in #67

### v0.6.0

- Addendum records respect eol param h/t (@sumahiremath)
- Response code parsing using custom 'filler' field in file control (@sumahiremath)

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
