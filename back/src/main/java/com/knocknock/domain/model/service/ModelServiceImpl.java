package com.knocknock.domain.model.service;

import com.knocknock.domain.model.dao.LikeModelRepository;
import com.knocknock.domain.model.dao.ModelRepository;
import com.knocknock.domain.model.domain.Model;
import com.knocknock.domain.model.dto.response.FindModelListResDto;
import com.knocknock.domain.model.dto.response.FindModelResDto;
import com.knocknock.domain.model.exception.ModelNotFoundException;
import com.knocknock.global.util.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ModelServiceImpl implements ModelService {

    private final ModelRepository modelRepository;
    private final LikeModelRepository likeModelRepository;
    private final JwtUtil jwtUtil;

    // 목록 조회
    @Override
    public List<FindModelListResDto> findModelList(String type, String keyword, String category) {
        // 현재 로그인한 회원의 user 기본키 가져오기
        Long userId = jwtUtil.getUserNo();
        List<FindModelListResDto> findModelListResDtoList = modelRepository.findModelList(userId, type, keyword, category);
        // 찜 되어있는지
        for (FindModelListResDto modelDto : findModelListResDtoList) {
            // 찜한 상품
            modelDto.setIsLiked(isLiked(userId, modelDto.getModelId()));
        }
        return modelRepository.findModelList(userId, type, keyword, category);
    }

    // 찜 여부 반환
    private boolean isLiked(long userId, long modelId) {
        return likeModelRepository.findLikeModelByUserAndModel(userId, modelId).isPresent();
    }

    // 상세 정보 조회
    @Override
    public FindModelResDto findModel(long modelId) {
        Model model = modelRepository.findModelById(modelId).orElseThrow(() -> new ModelNotFoundException("해당하는 가전제품이 존재하지 않습니다."));
        // 찜한 가전제품 인지 확인
        // 현재 로그인한 회원의 user 기본키 가져오기
        Long userId = jwtUtil.getUserNo();
        return FindModelResDto.builder()
                .modelId(modelId)
                .category(model.getCategory().getName())
                .modelName(model.getName())
                .modelBrand(model.getBrand())
                .modelGrade(model.getGrade())
                .modelImg(model.getImg())
                .modelURL(model.getUrl())
                .usage(model.getCategory().getUsage())
                .modelUsage(model.getUsage())
                .usageUnit(model.getCategory().getUsageUnit())
                .usage2(model.getCategory().getUsage2())
                .modelUsage2(model.getUsage2())
                .usageUnit2(model.getCategory().getUsageUnit2())
                .usage3(model.getCategory().getUsage3())
                .modelUsage3(model.getUsage3())
                .usageUnit3(model.getCategory().getUsageUnit3())
                .modelCo2(model.getCo2())
                .modelCost(model.getCost())
//                .releasedDate(model.getReleasedDate())
                .isLiked(isLiked(userId, modelId))
                .build();
    }


}
