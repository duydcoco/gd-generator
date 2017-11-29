package ${meta.queryModelPackage};

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.HashSet;
import java.io.Serializable;
import java.util.stream.Collectors;

import io.gd.generator.meta.querymodel.OrderBy;
<#if meta.useLombok>

import lombok.Getter;
import lombok.Setter;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
</#if>
<#if meta.importFullTypes??>
<#list meta.importFullTypes as importFullType>
import ${importFullType};
</#list>
</#if>

<#if meta.useLombok>
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
</#if>
public class ${meta.type} implements Serializable {
	<#if meta.queryModelFields??>
	<#list meta.queryModelFields as queryModelField>

	private ${queryModelField.type}<#if queryModelField.array>[]</#if> ${queryModelField.name};
	</#list>
	</#if>

	private Integer pageNumber;

	private Integer pageSize;

	private List<OrderBy> orderByList=new ArrayList<OrderBy>();

	<#if !meta.useLombok>
	<#if meta.queryModelFields??>
	<#list meta.queryModelFields as queryModelField>

	public ${queryModelField.type}<#if queryModelField.array>[]</#if> get${queryModelField.name?cap_first}() {
		return ${queryModelField.name};
	}

	public void set${queryModelField.name?cap_first}(${queryModelField.type}<#if queryModelField.array>[]</#if> ${queryModelField.name}) {
		this.${queryModelField.name} = ${queryModelField.name};
	}
	</#list>
	</#if>

	public Integer getPageNumber() {
		return pageNumber;
	}

	public void setPageNumber(Integer pageNumber) {
		this.pageNumber = pageNumber;
	}

	public Integer getPageSize() {
		return pageSize;
	}

	public void setPageSize(Integer pageSize) {
		this.pageSize = pageSize;
	}

	</#if>

	public void addOrderBy(OrderBy orderBy){
    	if(orderByList==null){
    		this.orderByList = new ArrayList<OrderBy>();
        }
		if(null==orderBy){
			return;
		}
		String orderByStr = orderBy.toString();
		if(null!=orderByStr||orderByStr.length()!=0){
			String orderByProp = orderByStr.split(" ")[0];
			if(!fieldNames.contains(orderByProp)){
				throw new IllegalArgumentException("field:"+orderByProp+" not found");
			}
			this.orderByList.add(orderBy);
		}
	}

	public Long getOffset() {
		if (pageNumber == null || pageSize == null) {
			return null;
		}
		return ((long) pageNumber - 1) * pageSize;
	}

    public String getOrderByAndDirection() {
        if (null==orderByList || orderByList.size()==0) {
            return null;
        }
        List<String> tranStrList = orderByList
                .stream()
                .map(item->{
                        String[] strArray = item.toString().split(" ");
                        return camelToUnderline(strArray[0])+" "+strArray[1];
                })
                .collect(Collectors.toList());
        return String.join(",",tranStrList);
    }

	private String camelToUnderline(String param) {
		if (param == null || "".equals(param.trim())) {
			return "";
		}
		int len = param.length();
		StringBuilder sb = new StringBuilder(len);
		for (int i = 0; i < len; i++) {
			char c = param.charAt(i);
			if (Character.isUpperCase(c)) {
				sb.append("_");
				sb.append(Character.toLowerCase(c));
			} else {
				sb.append(c);
			}
		}
		return sb.toString();
	}

	private static Set<String> fieldNames = new HashSet<>();

	static {
		<#if meta.fieldNames??>
		<#list meta.fieldNames as fieldName>
		fieldNames.add("${fieldName}");
		</#list>
		</#if>
	}

}