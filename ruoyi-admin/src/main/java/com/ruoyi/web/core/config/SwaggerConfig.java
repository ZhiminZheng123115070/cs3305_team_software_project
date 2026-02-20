package com.ruoyi.web.core.config;

import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import com.ruoyi.common.config.RuoYiConfig;
import io.swagger.annotations.ApiOperation;
import io.swagger.models.auth.In;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.ApiKey;
import springfox.documentation.service.AuthorizationScope;
import springfox.documentation.service.Contact;
import springfox.documentation.service.SecurityReference;
import springfox.documentation.service.SecurityScheme;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spi.service.contexts.SecurityContext;
import springfox.documentation.spring.web.plugins.Docket;

/**
 * Swagger2 API Configuration
 * 
 * @author ruoyi
 */
@Configuration
public class SwaggerConfig
{
    /** System Basic Configuration */
    @Autowired
    private RuoYiConfig ruoyiConfig;

    /** Whether to Enable Swagger */
    @Value("${swagger.enabled}")
    private boolean enabled;

    /** Set Unified Prefix for Requests */
    @Value("${swagger.pathMapping}")
    private String pathMapping;

    /**
     * Create API
     */
    @Bean
    public Docket createRestApi()
    {
        return new Docket(DocumentationType.OAS_30)
                // Whether to Enable Swagger
                .enable(enabled)
                // Used to Create Basic Information for This API, Displayed in Document Pages (Custom Display Information)
                .apiInfo(apiInfo())
                // Set Which Interfaces to Expose to Swagger
                .select()
                // Scan All APIs with Annotations, This Method is More Flexible
                .apis(RequestHandlerSelectors.withMethodAnnotation(ApiOperation.class))
                // Scan Swagger Annotations in Specified Package
                // .apis(RequestHandlerSelectors.basePackage("com.ruoyi.project.tool.swagger"))
                // Scan All .apis(RequestHandlerSelectors.any())
                .paths(PathSelectors.any())
                .build()
                /* Set Security Mode, Swagger Can Set Access Token */
                .securitySchemes(securitySchemes())
                .securityContexts(securityContexts())
                .pathMapping(pathMapping);
    }

    /**
     * Security Mode, Here Specify Token Passed Through Authorization Header
     */
    private List<SecurityScheme> securitySchemes()
    {
        List<SecurityScheme> apiKeyList = new ArrayList<SecurityScheme>();
        apiKeyList.add(new ApiKey("Authorization", "Authorization", In.HEADER.toValue()));
        return apiKeyList;
    }

    /**
     * Security Context
     */
    private List<SecurityContext> securityContexts()
    {
        List<SecurityContext> securityContexts = new ArrayList<>();
        securityContexts.add(
                SecurityContext.builder()
                        .securityReferences(defaultAuth())
                        .operationSelector(o -> o.requestMappingPattern().matches("/.*"))
                        .build());
        return securityContexts;
    }

    /**
     * Default Security Reference
     */
    private List<SecurityReference> defaultAuth()
    {
        AuthorizationScope authorizationScope = new AuthorizationScope("global", "accessEverything");
        AuthorizationScope[] authorizationScopes = new AuthorizationScope[1];
        authorizationScopes[0] = authorizationScope;
        List<SecurityReference> securityReferences = new ArrayList<>();
        securityReferences.add(new SecurityReference("Authorization", authorizationScopes));
        return securityReferences;
    }

    /**
     * Add Summary Information
     */
    private ApiInfo apiInfo()
    {
        // Customize with ApiInfoBuilder
        return new ApiInfoBuilder()
                // Set Title
                .title("Title: RuoYi Management System_API Documentation")
                // Description
                .description("Description: Used to manage personnel information of companies under the group, specifically including XXX, XXX modules...")
                // Author Information
                .contact(new Contact(ruoyiConfig.getName(), null, null))
                // Version
                .version("Version:" + ruoyiConfig.getVersion())
                .build();
    }
}
