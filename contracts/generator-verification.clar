;; Generator Verification Contract
;; Validates energy producers and manages their verification status

(define-data-var admin principal tx-sender)

;; Data map to store verified generators
(define-map verified-generators
  principal
  {
    name: (string-ascii 100),
    location: (string-ascii 100),
    capacity: uint,
    verified: bool
  }
)

;; Public function to register a generator
;; Can only be called by the admin
(define-public (register-generator (generator-principal principal) (name (string-ascii 100)) (location (string-ascii 100)) (capacity uint))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (ok (map-set verified-generators generator-principal {
      name: name,
      location: location,
      capacity: capacity,
      verified: true
    }))
  )
)

;; Public function to check if a generator is verified
(define-read-only (is-verified (generator-principal principal))
  (match (map-get? verified-generators generator-principal)
    generator-data (get verified generator-data)
    false
  )
)

;; Public function to get generator details
(define-read-only (get-generator-details (generator-principal principal))
  (map-get? verified-generators generator-principal)
)

;; Function to transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (ok (var-set admin new-admin))
  )
)
