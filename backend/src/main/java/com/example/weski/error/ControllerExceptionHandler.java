package com.example.weski.error;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice

public class ControllerExceptionHandler {
    @ExceptionHandler(NotFoundException.class)
    public final ResponseEntity<Error> exceptionHandler(NotFoundException e) {
        return new ResponseEntity<>(new Error(e.getMessage()), HttpStatus.BAD_REQUEST);
    }
}
