package com.greatkapital.encryptionservice.service;

public interface EncryptionStrategy {
    String encrypt(String data) throws Exception;

    String getStrategyName();
}