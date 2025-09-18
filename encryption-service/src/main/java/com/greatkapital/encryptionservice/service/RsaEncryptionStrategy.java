package com.greatkapital.encryptionservice.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import javax.crypto.Cipher;
import java.nio.charset.StandardCharsets;
import java.security.KeyFactory;
import java.security.PublicKey;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;

@Service
public class RsaEncryptionStrategy implements EncryptionStrategy {

    private static final String ALGORITHM = "RSA";

    @Value("${encryption.rsa.public-key}")
    private String rsaPublicKeyString;

    @Override
    public String encrypt(String data) throws Exception {
        byte[] publicKeyBytes = Base64.getDecoder().decode(rsaPublicKeyString);
        X509EncodedKeySpec keySpec = new X509EncodedKeySpec(publicKeyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance(ALGORITHM);
        PublicKey publicKey = keyFactory.generatePublic(keySpec);

        Cipher cipher = Cipher.getInstance(ALGORITHM);
        cipher.init(Cipher.ENCRYPT_MODE, publicKey);
        byte[] encryptedBytes = cipher.doFinal(data.getBytes(StandardCharsets.UTF_8));
        return Base64.getEncoder().encodeToString(encryptedBytes);
    }

    @Override
    public String getStrategyName() {
        return "RSA";
    }
}