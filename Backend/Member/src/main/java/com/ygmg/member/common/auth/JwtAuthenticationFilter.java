package com.ygmg.member.common.auth;


import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ygmg.member.common.util.JwtTokenUtil;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.SignatureException;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;


/**
 * 요청 헤더에 jwt 토큰이 있는 경우, 토큰 검증 및 인증 처리 로직 정의.
 */
@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {
    private final JwtTokenUtil jwtTokenUtil;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        // Read the Authorization header, where the JWT Token should be
        // 헤더에서 JWT 를 받아옵니다.
        String headerAccessToken = jwtTokenUtil.resolveAccessToken(request);

        // 유효한 토큰인지 확인합니다.
        if (headerAccessToken != null) {
            // 어세스 토큰이 유효한 상황
            String accessToken = headerAccessToken.substring(7);
            try {
                if (jwtTokenUtil.validateToken(accessToken)) {
                    this.setAuthentication(accessToken); // true면 만료안되었다
                }
            }catch (ExpiredJwtException e){
                throw new JwtException("토큰 기한이 만료");
            }catch (IllegalArgumentException e){
                throw new JwtException("유효하지 않은 토큰");
            }catch (SignatureException e){
                throw new JwtException("사용자 인증 실패");
            }
        }
        filterChain.doFilter(request, response);
    }
    // SecurityContext 에 Authentication 객체를 저장합니다.
    public void setAuthentication(String token) {
        // 토큰으로부터 유저 정보를 받아옵니다.
        Authentication authentication = jwtTokenUtil.getAuthentication(token);
        // SecurityContext 에 Authentication 객체를 저장합니다.
        SecurityContextHolder.getContext().setAuthentication(authentication);

    }
}
