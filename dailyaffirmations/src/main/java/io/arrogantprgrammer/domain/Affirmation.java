package io.arrogantprgrammer.domain;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import jakarta.persistence.Entity;

@Entity
public class Affirmation extends PanacheEntity {

    private String text;

    private String author;

    public Affirmation(String author, String text) {
        this.author = author;
        this.text = text;
    }

    public Affirmation() {
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }
}
