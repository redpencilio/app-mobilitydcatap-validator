(define-resource validation-summary ()
  :class (s-prefix "shv:ValidationSummary")
  :properties `((:total-violations :integer ,(s-prefix "shv:totalViolations"))
                (:endpoint-url :string ,(s-prefix "ext:endpointUrl")))

  :has-many `((target-class-summary :via ,(s-prefix "shv:hasTargetClassSummary")
                                    :as "target-class-summaries"))

  :has-one `((validation-job :via ,(s-prefix "ext:shaclReport")
                             :inverse t
                             :as "shacl-job")
             (validation-job :via ,(s-prefix "ext:coverageReport")
                             :inverse t
                             :as "coverage-job")
             (validation-job :via ,(s-prefix "ext:vocabularyReport")
                             :inverse t
                             :as "vocabulary-job"))

  :resource-base (s-url "http://redpencil.data.gift/id/validation-summary/")
  :features '(include-uri)
  :on-path "validation-summaries")

(define-resource target-class-summary ()
  :class (s-prefix "shv:TargetClassSummary")
  :properties `((:target-class :url ,(s-prefix "shv:hasTargetClass"))
                (:resource-count :integer ,(s-prefix "shv:resourceCount")))

  :has-many `((rule-summary :via ,(s-prefix "shv:hasRuleSummary")
                            :as "rule-summaries"))

  :has-one `((validation-summary :via ,(s-prefix "shv:hasTargetClassSummary")
                                 :inverse t
                                 :as "validation-summary"))

  :resource-base (s-url "http://redpencil.data.gift/id/target-class-summary/")
  :features '(include-uri)
  :on-path "target-class-summaries")

(define-resource rule-summary ()
  :class (s-prefix "shv:RuleSummary")
  :properties `((:violation-count :integer ,(s-prefix "shv:violationCount"))
                (:rule :url ,(s-prefix "shv:hasRule"))
                (:rule-constraint :url ,(s-prefix "shv:hasRuleConstraint"))
                (:validation-result :url ,(s-prefix "shv:hasValidationResult"))
                (:severity :url ,(s-prefix "shv:hasSeverity"))
                (:constraint :url ,(s-prefix "shv:sourceConstraintComponent"))
                (:message :string ,(s-prefix "shv:message")))

  :has-many `((rule-violation :via ,(s-prefix "shv:hasRuleViolation")
                              :as "rule-violations"))

  :has-one `((target-class-summary :via ,(s-prefix "shv:hasRuleSummary")
                                   :inverse t
                                   :as "target-class-summary"))

  :resource-base (s-url "http://redpencil.data.gift/id/rule-summary/")
  :features '(include-uri)
  :on-path "rule-summaries")

(define-resource rule-violation ()
  :class (s-prefix "shv:RuleViolation")
  :properties `((:value :string ,(s-prefix "shv:value")))

  :has-one `((rule-summary :via ,(s-prefix "shv:hasRuleViolation")
                           :inverse t
                           :as "rule-summary"))

  :resource-base (s-url "http://redpencil.data.gift/id/rule-violation/")
  :features '(include-uri)
  :on-path "rule-violations")
