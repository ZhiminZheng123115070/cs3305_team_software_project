package com.team6.service.healthService;

import com.team6.request.UserInfoRequest;
import com.team6.response.HealthInfoRecordResponse;
import com.team6.response.UserInfoResponse;

import java.util.List;

/**
 * @author zhimin
 * 2026/2/18 01:32
 */
public interface IUserInfoService {

    /**
     * Add or update user info and write a snapshot to history. Returns the saved profile.
     */
    public UserInfoResponse insertOrUpdateUserInfoAndAddLog(UserInfoRequest request);

    public UserInfoResponse getUserInfoByUserId();

    public List<HealthInfoRecordResponse> getUserInfoHistoryByUserId();

}
