package com.ygmg.member.common.util;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;

import com.ygmg.member.common.auth.CustomUserDetailService;
import com.ygmg.member.common.auth.TokenInfo;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import io.jsonwebtoken.security.SignatureException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;


/**
 * jwt 토큰 유틸 정의.
 */
@Component
public class JwtTokenUtil {

    @Autowired
    private CustomUserDetailService customUserDetailService;

    private static String secretKey;

    private static long ACCESS_TOKEN_EXPIRE_TIME;  // 30분

    public static long REFRESH_TOKEN_EXPIRE_TIME;    // 7일


    public static final String TOKEN_PREFIX = "Bearer ";
    public static final String HEADER_STRING = "Authorization";
    public static final String ISSUER = "ResetContent";

    @Autowired
    public JwtTokenUtil(@Value("${jwt.secret}") String secretKey, @Value("${jwt.accessTokenExpiration}") long ACCESS_TOKEN_EXPIRE_TIME, @Value("${jwt.refreshTokenExpiration}") long REFRESH_TOKEN_EXPIRE_TIME) {
        this.secretKey = secretKey;
        this.ACCESS_TOKEN_EXPIRE_TIME = ACCESS_TOKEN_EXPIRE_TIME;
        this.REFRESH_TOKEN_EXPIRE_TIME = REFRESH_TOKEN_EXPIRE_TIME;
    }

    //토큰 생성
    public TokenInfo generateToken(String userId, String accessToken, String refreshToken){

        return TokenInfo.builder()
                .userId(userId)
                .grantType(TOKEN_PREFIX)
                .authorization(accessToken)
                .refreshToken(refreshToken)
                .accessTokenExpirationTime(ACCESS_TOKEN_EXPIRE_TIME)
                .refreshTokenExpirationTime(REFRESH_TOKEN_EXPIRE_TIME)
                .build();

    }


    //accessToken 생성
    public  String createAccessToken(String userId) {
        Date now = new Date();
        Date expires =  new Date(now.getTime() + ACCESS_TOKEN_EXPIRE_TIME);
        return JWT.create()
                .withSubject(userId)
                .withExpiresAt(expires)
                .withIssuer(ISSUER)
                .withIssuedAt(Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant()))
                .sign(Algorithm.HMAC512(secretKey.getBytes()));
    }

    //refreshToken 생성
    public  String createRefreshToken(String userId) {
        Date now = new Date();
        Date expires =  new Date(now.getTime() + REFRESH_TOKEN_EXPIRE_TIME);
        return JWT.create()
                .withSubject(userId)
                .withExpiresAt(expires)
                .withIssuer(ISSUER)
                .withIssuedAt(Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant()))
                .sign(Algorithm.HMAC512(secretKey.getBytes()));
    }

    // 토큰에서 회원 정보(아이디) 추출
    public String getUserEmail(String jwtToken) {
        return Jwts.parserBuilder().setSigningKey(Keys.hmacShaKeyFor(secretKey.getBytes(StandardCharsets.UTF_8)))
                .build().parseClaimsJws(jwtToken).getBody().getSubject();
    }

    //토큰 유효시간 체크
    public boolean validateToken(String jwtToken) {
        Date expiration = new Date();
        expiration = Jwts.parserBuilder().setSigningKey(Keys.hmacShaKeyFor(secretKey.getBytes(StandardCharsets.UTF_8)))
                .build().parseClaimsJws(jwtToken)
                .getBody().getExpiration();

        return expiration.after(new Date());
    }

    public Authentication getAuthentication(String token) {
        UserDetails userDetails = customUserDetailService.loadUserByUsername(this.getUserEmail(token));
        return new UsernamePasswordAuthenticationToken(userDetails, "", userDetails.getAuthorities());
    }

    // accessToken HEADER 체크
    public String resolveAccessToken(HttpServletRequest request) {
        if(request.getHeader("authorization") != null )
            return request.getHeader("authorization");
        return null;
    }

//    public Role getRoles(String userId) {
//        return userRepository.findByUserEmail(userId).get().getRole();
//    }

    //    public static void handleError(String token) {
//        JWTVerifier verifier = JWT
//                .require(Algorithm.HMAC512(secretKey.getBytes()))
//                .withIssuer(ISSUER)
//                .build();
//
//        try {
//            verifier.verify(token.replace(TOKEN_PREFIX, ""));
//        } catch (AlgorithmMismatchException ex) {
//            throw ex;
//        } catch (InvalidClaimException ex) {
//            throw ex;
//        } catch (SignatureGenerationException ex) {
//            throw ex;
//        } catch (SignatureVerificationException ex) {
//            throw ex;
//        } catch (TokenExpiredException ex) {
//            throw ex;
//        } catch (JWTCreationException ex) {
//            throw ex;
//        } catch (JWTDecodeException ex) {
//            throw ex;
//        } catch (JWTVerificationException ex) {
//            throw ex;
//        } catch (Exception ex) {
//            throw ex;
//
//        }
//    }
}
