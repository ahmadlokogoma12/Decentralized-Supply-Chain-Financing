;; supplier-verification.clar
;; This contract validates legitimate vendors in the supply chain

(define-data-var admin principal tx-sender)

;; Map to store verified suppliers
(define-map verified-suppliers principal
  {
    company-name: (string-utf8 100),
    registration-number: (string-utf8 50),
    verification-date: uint,
    is-active: bool
  }
)

;; Public function to verify a supplier (only admin can call)
(define-public (verify-supplier
    (supplier principal)
    (company-name (string-utf8 100))
    (registration-number (string-utf8 50))
  )
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u1)) ;; Only admin can verify
    (ok (map-set verified-suppliers supplier {
      company-name: company-name,
      registration-number: registration-number,
      verification-date: block-height,
      is-active: true
    }))
  )
)

;; Public function to deactivate a supplier
(define-public (deactivate-supplier (supplier principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u1))
    (asserts! (is-some (map-get? verified-suppliers supplier)) (err u2))
    (let ((supplier-data (unwrap-panic (map-get? verified-suppliers supplier))))
      (ok (map-set verified-suppliers supplier
        (merge supplier-data { is-active: false })
      ))
    )
  )
)

;; Read-only function to check if a supplier is verified
(define-read-only (is-verified-supplier (supplier principal))
  (match (map-get? verified-suppliers supplier)
    supplier-data (and (get is-active supplier-data) true)
    false
  )
)

;; Read-only function to get supplier details
(define-read-only (get-supplier-details (supplier principal))
  (map-get? verified-suppliers supplier)
)

;; Function to transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u1))
    (ok (var-set admin new-admin))
  )
)
