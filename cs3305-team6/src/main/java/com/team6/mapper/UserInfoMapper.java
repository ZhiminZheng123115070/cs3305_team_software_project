package com.team6.mapper;

import com.team6.pojo.UserInfo;
import org.apache.ibatis.annotations.Mapper;

/**
 * @author zhimin
 * 2026/2/18 00:53
 */
@Mapper
public interface UserInfoMapper {

    int insertOrUpdate(UserInfo userInfo);

    UserInfo selectByUserId(Long userId);
}
