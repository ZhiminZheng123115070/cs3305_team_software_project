package com.ruoyi.framework.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.authentication.logout.LogoutFilter;
import org.springframework.web.filter.CorsFilter;
import com.ruoyi.framework.config.properties.PermitAllUrlProperties;
import com.ruoyi.framework.security.filter.JwtAuthenticationTokenFilter;
import com.ruoyi.framework.security.handle.AuthenticationEntryPointImpl;
import com.ruoyi.framework.security.handle.LogoutSuccessHandlerImpl;

/**
 * Spring Security Configuration
 * 
 * @author ruoyi
 */
@EnableMethodSecurity(prePostEnabled = true, securedEnabled = true)
@Configuration
public class SecurityConfig
{
    /**
     * Custom user authentication logic
     */
    @Autowired
    private UserDetailsService userDetailsService;
    
    /**
     * Authentication failure handler
     */
    @Autowired
    private AuthenticationEntryPointImpl unauthorizedHandler;

    /**
     * Logout handler
     */
    @Autowired
    private LogoutSuccessHandlerImpl logoutSuccessHandler;

    /**
     * Token authentication filter
     */
    @Autowired
    private JwtAuthenticationTokenFilter authenticationTokenFilter;
    
    /**
     * CORS filter
     */
    @Autowired
    private CorsFilter corsFilter;

    /**
     * URLs allowed for anonymous access
     */
    @Autowired
    private PermitAllUrlProperties permitAllUrl;

    /**
     * Authentication implementation
     */
    @Bean
    public AuthenticationManager authenticationManager()
    {
        DaoAuthenticationProvider daoAuthenticationProvider = new DaoAuthenticationProvider();
        daoAuthenticationProvider.setUserDetailsService(userDetailsService);
        daoAuthenticationProvider.setPasswordEncoder(bCryptPasswordEncoder());
        return new ProviderManager(daoAuthenticationProvider);
    }

    /**
     * anyRequest          |   Match all request paths
     * access              |   Accessible when SpringEl expression result is true
     * anonymous           |   Anonymous can access
     * denyAll             |   User cannot access
     * fullyAuthenticated  |   Fully authenticated users can access (non-remember-me auto-login)
     * hasAnyAuthority     |   If parameter exists, parameter represents permission, any permission can access
     * hasAnyRole          |   If parameter exists, parameter represents role, any role can access
     * hasAuthority        |   If parameter exists, parameter represents permission, that permission can access
     * hasIpAddress        |   If parameter exists, parameter represents IP address, if user IP matches parameter, can access
     * hasRole             |   If parameter exists, parameter represents role, that role can access
     * permitAll           |   User can access arbitrarily
     * rememberMe          |   Allow users logged in via remember-me to access
     * authenticated       |   Accessible after user login
     */
    @Bean
    protected SecurityFilterChain filterChain(HttpSecurity httpSecurity) throws Exception
    {
        return httpSecurity
            // Disable CSRF, because session is not used
            .csrf(csrf -> csrf.disable())
            // Disable HTTP response headers
            .headers((headersCustomizer) -> {
                headersCustomizer.cacheControl(cache -> cache.disable()).frameOptions(options -> options.sameOrigin());
            })
            // Authentication failure handler
            .exceptionHandling(exception -> exception.authenticationEntryPoint(unauthorizedHandler))
            // Token-based, so session is not needed
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            // Annotation marked URLs allowed for anonymous access
            .authorizeHttpRequests((requests) -> {
                permitAllUrl.getUrls().forEach(url -> requests.antMatchers(url).permitAll());
                // For login, register, captchaImage, allow anonymous access
                requests.antMatchers("/login", "/register", "/captchaImage").permitAll()
                    // Static resources, can be accessed anonymously
                    .antMatchers(HttpMethod.GET, "/", "/*.html", "/**/*.html", "/**/*.css", "/**/*.js", "/profile/**").permitAll()
                    .antMatchers("/swagger-ui.html", "/swagger-resources/**", "/webjars/**", "/*/api-docs", "/druid/**").permitAll()
                    // All requests except the above require authentication
                    .anyRequest().authenticated();
            })
            // Add Logout filter
            .logout(logout -> logout.logoutUrl("/logout").logoutSuccessHandler(logoutSuccessHandler))
            // Add JWT filter
            .addFilterBefore(authenticationTokenFilter, UsernamePasswordAuthenticationFilter.class)
            // Add CORS filter
            .addFilterBefore(corsFilter, JwtAuthenticationTokenFilter.class)
            .addFilterBefore(corsFilter, LogoutFilter.class)
            .build();
    }

    /**
     * Strong hash encryption implementation
     */
    @Bean
    public BCryptPasswordEncoder bCryptPasswordEncoder()
    {
        return new BCryptPasswordEncoder();
    }
}
