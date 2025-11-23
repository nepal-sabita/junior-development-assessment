package com.payment.service;

import io.micronaut.context.annotation.Prototype;
import jakarta.inject.Inject;
import java.math.BigDecimal;
import java.util.List;

/**
 * BUGGY CODE - DO NOT USE IN PRODUCTION
 * This service has multiple critical bugs related to concurrency and error handling.
 * Candidates should identify and fix these issues.
 */
@Singleton
public class PaymentProcessingService {
    
    private final PaymentRepository paymentRepository;
    private final AuditService auditService;
    private BigDecimal totalProcessed = BigDecimal.ZERO;
    
    @Inject
    public PaymentProcessingService(PaymentRepository paymentRepository, 
                                   AuditService auditService) {
        this.paymentRepository = paymentRepository;
        this.auditService = auditService;
    }
    
    /**
     * Processes a batch of payments in parallel
     * WARNING: This method has critical bugs!
     */
    public void processPaymentBatch(List<Payment> payments) {
        payments.parallelStream().forEach(payment -> {
            try {
                // Validate payment
                if (payment.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
                    throw new IllegalArgumentException("Invalid amount");
                }
                
                // BUG 1: Non-thread-safe operation on shared mutable state
                synchronized(this) {
                totalProcessed = totalProcessed.add(payment.getAmount());}
                // Process payment
                payment.setStatus("COMPLETED");
                paymentRepository.update(payment);
                
                // Audit log
                auditService.log("Payment " + payment.getId() + " processed");
                
            } catch (Exception e) {
                // BUG 2: Failed status set but never persisted to database
                payment.setStatus("FAILED");
                paymentRepository.update(payment); // solves the issue related to not adding to db
                // Note: Not saving failed status to DB
            }
        });
        
        // BUG 3: No transaction management - partial failures leave inconsistent state
        // BUG 4: No error propagation - calling code doesn't know if processing failed
    }
    
    public BigDecimal getTotalProcessed() {
        return totalProcessed;
    }
}
