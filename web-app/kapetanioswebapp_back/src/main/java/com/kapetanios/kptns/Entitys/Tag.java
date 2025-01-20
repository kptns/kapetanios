package com.kapetanios.kptns.Entitys;

import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@RequiredArgsConstructor
public class Tag {
    private final String name;
    private final String value;

    @Override
    public String toString() {
        return name + ":" + value;
    }
}
