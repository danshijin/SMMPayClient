package com.eliteams.pay.web.security;

import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.springframework.stereotype.Component;

import com.eliteams.pay.web.model.User;

/**
 * 用户身份验证,授权 Realm 组件
 * 
 * @since 2014年6月11日 上午11:35:28
 **/
@Component(value = "securityRealm")
public class SecurityRealm extends AuthorizingRealm {

    /**
     * 权限检查
     */
    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
        SimpleAuthorizationInfo authorizationInfo = new SimpleAuthorizationInfo();
        //        String username = String.valueOf(principals.getPrimaryPrincipal());

        //        final User user = userService.selectByUsername(username);
        //        final List<Role> roleInfos = roleService.selectRolesByUserId(user.getId());
        //        for (Role role : roleInfos) {
        //            // 添加角色
        //            System.err.println(role);
        //            authorizationInfo.addRole(role.getRoleSign());
        //
        //            final List<Permission> permissions = permissionService.selectPermissionsByRoleId(role.getId());
        //            for (Permission permission : permissions) {
        //                // 添加权限
        //                System.err.println(permission);
        //                authorizationInfo.addStringPermission(permission.getPermissionSign());
        //            }
        //        }
        return authorizationInfo;
    }

    /**
     * 登录验证
     */
    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
        String username = String.valueOf(token.getPrincipal());
        String password = new String((char[]) token.getCredentials());
        // 通过数据库进行验证
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        SimpleAuthenticationInfo authenticationInfo = new SimpleAuthenticationInfo(username, password, getName());
        return authenticationInfo;
    }

}
