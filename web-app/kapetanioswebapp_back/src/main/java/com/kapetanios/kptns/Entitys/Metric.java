package com.kapetanios.kptns.Entitys;

import java.util.ArrayList;
import java.util.List;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class Metric {
    private String name;
    private Number value;
    private List<String> tags;

    public static final class Builder {
        private List<String> tags = new ArrayList<>();

        public Builder withTags(List<Tag> theTags) {
            theTags.forEach(tag -> tags.add(tag.toString()));
            return this;
        }

        public Builder tag(String tag) {
            tags.add(tag);
            return this;
        }

        public Builder tag(Tag tag) {
            tags.add(tag.toString());
            return this;
        }
    }
}
