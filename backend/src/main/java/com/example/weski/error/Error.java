package com.example.weski.error;

import lombok.AllArgsConstructor;
import lombok.Getter;


public record Error(String message) {
    public Error(String message) {
        this.message = message;
    }
    @Override
    public String message() {
        return message;
    }
}
