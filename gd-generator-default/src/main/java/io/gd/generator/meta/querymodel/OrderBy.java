package io.gd.generator.meta.querymodel;

public class OrderBy {

    private StringBuilder stringBuilder=new StringBuilder();

    public OrderBy asc(String propName){
        stringBuilder.append(propName).append(" ").append("asc");
        return this;
    }
    public OrderBy desc(String propName){
        stringBuilder.append(propName).append(" ").append("desc");
        return this;
    }

    @Override
    public String toString() {
        return stringBuilder.toString();
    }
}
